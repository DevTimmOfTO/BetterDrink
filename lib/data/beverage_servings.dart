import '../l10n/gen/app_localizations.dart';
import '../models/beverage_kind.dart';

/// A one-tap serving size offered under a drink kind's quick-add button, so
/// logging "a cup of coffee" doesn't require knowing its millilitres.
class BeverageServing {
  const BeverageServing({required this.label, required this.volumeMl});

  final String label;
  final int volumeMl;
}

/// Common serving sizes per drink kind — rough conventions, which is why
/// the custom-amount option stays available alongside them. Labels are
/// localized via [loc], same as [typicalDrinks] on the Alcohol tab.
List<BeverageServing> servingsFor(BeverageKind kind, AppLocalizations loc) =>
    switch (kind) {
      BeverageKind.coffee => [
          BeverageServing(label: loc.servingEspresso, volumeMl: 60),
          BeverageServing(label: loc.servingCup, volumeMl: 125),
          BeverageServing(label: loc.servingMug, volumeMl: 250),
        ],
      BeverageKind.tea => [
          BeverageServing(label: loc.servingGlass, volumeMl: 200),
          BeverageServing(label: loc.servingMug, volumeMl: 350),
          BeverageServing(label: loc.servingPot, volumeMl: 500),
        ],
      BeverageKind.water => [
          BeverageServing(label: loc.servingGlass, volumeMl: 250),
          BeverageServing(label: loc.servingBottle, volumeMl: 500),
          BeverageServing(label: loc.servingLargeBottle, volumeMl: 750),
        ],
    };
