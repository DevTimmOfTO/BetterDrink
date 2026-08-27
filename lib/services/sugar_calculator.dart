/// Grams of sugar in a drink of the given size and sugar concentration.
double gramsOfSugar({required double volumeMl, required double sugarPer100ml}) {
  return volumeMl * sugarPer100ml / 100;
}

/// WHO's recommended daily limit for free sugars: under 10% of a roughly
/// 2000kcal adult diet, i.e. about 50g/day. Used to nudge the user when
/// today's logged drinks alone have already passed it -- an informational
/// guideline, not medical advice.
const double recommendedDailySugarLimitG = 50;
