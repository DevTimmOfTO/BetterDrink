import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';

/// A kind of non-alcoholic drink loggable on the Hydration tab.
///
/// [hydrationFactor] is the share of the poured volume that counts toward
/// the daily goal — caffeine is mildly diuretic, so coffee and tea are
/// credited below their full volume. Like the BAC estimate on the Alcohol
/// tab, these factors are a pragmatic convention for informational
/// tracking, not a clinical measure.
enum BeverageKind {
  water(
    storageKey: 'water',
    hydrationFactor: 1.0,
    icon: Icons.water_drop_rounded,
  ),
  coffee(
    storageKey: 'coffee',
    hydrationFactor: 0.8,
    icon: Icons.coffee_rounded,
  ),
  tea(
    storageKey: 'tea',
    hydrationFactor: 0.9,
    icon: Icons.emoji_food_beverage_rounded,
  );

  const BeverageKind({
    required this.storageKey,
    required this.hydrationFactor,
    required this.icon,
  });

  /// Stable identifier written to `shared_preferences`. Kept separate from
  /// [name] so renaming an enum value can't silently orphan stored entries.
  final String storageKey;

  final double hydrationFactor;
  final IconData icon;

  /// Millilitres credited toward the daily goal for [volumeMl] poured.
  int hydrationMl(int volumeMl) => (volumeMl * hydrationFactor).round();

  String label(AppLocalizations loc) => switch (this) {
        BeverageKind.water => loc.beverageWater,
        BeverageKind.coffee => loc.beverageCoffee,
        BeverageKind.tea => loc.beverageTea,
      };

  /// Why this drink counts below its poured volume, or null for [water],
  /// which is credited in full and needs no explanation. Worded per kind:
  /// only coffee is reliably caffeinated, whereas a herbal or fruit tea
  /// isn't, so tea points at logging those as water instead.
  String? factorNote(AppLocalizations loc) {
    final percent = (hydrationFactor * 100).round();
    return switch (this) {
      BeverageKind.water => null,
      BeverageKind.coffee => loc.beverageFactorNoteCoffee(percent),
      BeverageKind.tea => loc.beverageFactorNoteTea(percent),
    };
  }

  /// Resolves a stored key, falling back to [water] — entries logged before
  /// drink kinds existed have no key at all and were all water.
  static BeverageKind fromStorageKey(String? key) => values.firstWhere(
        (kind) => kind.storageKey == key,
        orElse: () => water,
      );
}
