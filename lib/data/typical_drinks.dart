import 'package:flutter/material.dart';

/// A preset drink shown on the Alcohol tab's quick-add grid, with typical
/// serving size and strength so the user doesn't have to know their ABV.
class TypicalDrink {
  const TypicalDrink({
    required this.name,
    required this.volumeMl,
    required this.abvPercent,
    required this.icon,
  });

  final String name;
  final double volumeMl;
  final double abvPercent;
  final IconData icon;
}

/// Rough, commonly-cited averages — real drinks vary a lot by brand/pour.
const List<TypicalDrink> typicalDrinks = [
  TypicalDrink(
    name: 'Beer',
    volumeMl: 500,
    abvPercent: 5,
    icon: Icons.sports_bar_rounded,
  ),
  TypicalDrink(
    name: 'Small beer',
    volumeMl: 330,
    abvPercent: 5,
    icon: Icons.sports_bar_rounded,
  ),
  TypicalDrink(
    name: 'Wine',
    volumeMl: 150,
    abvPercent: 12,
    icon: Icons.wine_bar_rounded,
  ),
  TypicalDrink(
    name: 'Sparkling wine',
    volumeMl: 100,
    abvPercent: 11,
    icon: Icons.wine_bar_rounded,
  ),
  TypicalDrink(
    name: 'Shot / spirit',
    volumeMl: 40,
    abvPercent: 40,
    icon: Icons.local_bar_rounded,
  ),
  TypicalDrink(
    name: 'Mixed drink',
    volumeMl: 300,
    abvPercent: 8,
    icon: Icons.local_bar_rounded,
  ),
  TypicalDrink(
    name: 'Cocktail',
    volumeMl: 200,
    abvPercent: 15,
    icon: Icons.local_bar_rounded,
  ),
];
