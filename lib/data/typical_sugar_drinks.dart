import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';

/// A preset drink shown on the Sugar tab's quick-add grid, with typical
/// serving size and sugar concentration so the user doesn't have to look up
/// a nutrition label.
class TypicalSugarDrink {
  const TypicalSugarDrink({
    required this.name,
    required this.volumeMl,
    required this.sugarPer100ml,
    required this.icon,
  });

  final String name;
  final double volumeMl;

  /// Grams of sugar per 100ml, the sugar-drink analogue of ABV%.
  final double sugarPer100ml;
  final IconData icon;
}

/// Rough, commonly-cited averages — real products vary by brand. Names are
/// localized via [loc].
List<TypicalSugarDrink> typicalSugarDrinks(AppLocalizations loc) => [
      TypicalSugarDrink(
        name: loc.drinkCola,
        volumeMl: 330,
        sugarPer100ml: 10.6,
        icon: Icons.local_drink_rounded,
      ),
      TypicalSugarDrink(
        name: loc.drinkLemonade,
        volumeMl: 330,
        sugarPer100ml: 9,
        icon: Icons.local_drink_rounded,
      ),
      TypicalSugarDrink(
        name: loc.drinkEnergyDrink,
        volumeMl: 250,
        sugarPer100ml: 11,
        icon: Icons.bolt_rounded,
      ),
      TypicalSugarDrink(
        name: loc.drinkOrangeJuice,
        volumeMl: 250,
        sugarPer100ml: 9,
        icon: Icons.emoji_food_beverage_rounded,
      ),
      TypicalSugarDrink(
        name: loc.drinkIcedTea,
        volumeMl: 330,
        sugarPer100ml: 8,
        icon: Icons.local_cafe_rounded,
      ),
      TypicalSugarDrink(
        name: loc.drinkSportsDrink,
        volumeMl: 500,
        sugarPer100ml: 6,
        icon: Icons.sports_rounded,
      ),
    ];
