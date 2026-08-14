import '../models/drink_entry.dart';
import '../models/user_profile.dart';

/// Average density of pure ethanol, in grams per millilitre.
const double ethanolDensityGPerMl = 0.789;

/// Average alcohol elimination rate, in permille (‰) BAC per hour. This is
/// a population average used by the classic Widmark formula (real rates
/// vary roughly 0.10-0.20‰/h by person).
const double eliminationRatePerHour = 0.15;

/// Grams of pure alcohol in a drink of the given size and strength.
double gramsOfAlcohol({required double volumeMl, required double abvPercent}) {
  return volumeMl * (abvPercent / 100) * ethanolDensityGPerMl;
}

/// Widmark distribution factor: the fraction of body weight alcohol
/// effectively distributes into. A lower factor means the same amount of
/// alcohol produces a higher peak BAC.
double widmarkFactor(Sex sex) {
  switch (sex) {
    case Sex.male:
      return 0.68;
    case Sex.female:
      return 0.55;
    case Sex.other:
      return 0.615; // midpoint, used when sex isn't specified as male/female
  }
}

/// Estimates blood alcohol concentration (in permille, ‰) at [at] from
/// [drinks], using the classic Widmark formula. Each drink is assumed to be
/// absorbed instantly at its own timestamp and then eliminated at a
/// constant rate from then on; a drink's contribution never goes negative
/// on its own, so it stops dragging the total down once it hits zero.
///
/// This is a rough estimate for informational purposes only. It is not
/// medical advice and must never be used to judge fitness to drive.
double estimateBac({
  required List<DrinkEntry> drinks,
  required DateTime at,
  required UserProfile profile,
}) {
  final r = widmarkFactor(profile.sex);
  final bodyWeightKg = profile.weightKg <= 0 ? 1 : profile.weightKg;

  var total = 0.0;
  for (final drink in drinks) {
    if (drink.timestamp.isAfter(at)) continue;
    final grams =
        gramsOfAlcohol(volumeMl: drink.volumeMl, abvPercent: drink.abvPercent);
    final peak = grams / (bodyWeightKg * r);
    final hoursSince = at.difference(drink.timestamp).inMilliseconds / 3600000;
    final remaining = peak - eliminationRatePerHour * hoursSince;
    if (remaining > 0) total += remaining;
  }
  return total;
}

/// How long until [bac] (in permille) reaches zero at the constant
/// elimination rate.
Duration timeToZeroBac(double bac) {
  if (bac <= 0) return Duration.zero;
  final hours = bac / eliminationRatePerHour;
  return Duration(milliseconds: (hours * 3600000).round());
}
