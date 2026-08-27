import '../models/chart_point.dart';
import '../models/drink_entry.dart';
import '../models/sugar_entry.dart';
import 'alcohol_calculator.dart';
import 'date_key.dart';
import 'sugar_calculator.dart';

/// Sums grams of pure alcohol per day from [drinks], keyed by [dateKey].
/// Pure and side-effect free — [drinks] is expected to already be the
/// retained history (see [AlcoholService]'s 30-day retention window).
Map<String, double> bucketDrinksByDay(List<DrinkEntry> drinks) {
  final buckets = <String, double>{};
  for (final drink in drinks) {
    final key = dateKey(drink.timestamp);
    final grams =
        gramsOfAlcohol(volumeMl: drink.volumeMl, abvPercent: drink.abvPercent);
    buckets[key] = (buckets[key] ?? 0) + grams;
  }
  return buckets;
}

/// Sums grams of sugar per day from [drinks], keyed by [dateKey]. Pure and
/// side-effect free — [drinks] is expected to already be the retained
/// history (see [SugarService]'s 30-day retention window).
Map<String, double> bucketSugarByDay(List<SugarEntry> drinks) {
  final buckets = <String, double>{};
  for (final drink in drinks) {
    final key = dateKey(drink.timestamp);
    final grams = gramsOfSugar(
      volumeMl: drink.volumeMl,
      sugarPer100ml: drink.sugarPer100ml,
    );
    buckets[key] = (buckets[key] ?? 0) + grams;
  }
  return buckets;
}

/// Normalizes [buckets] (a [dateKey] mapped to a value) into an ordered,
/// oldest-first list of the last [days] days ending today, filling in
/// zeros for days with no data — ready for direct chart consumption.
List<ChartPoint> fillMissingDays(
  Map<String, num> buckets, {
  required int days,
  DateTime? now,
}) {
  final today = now ?? DateTime.now();
  final anchor = DateTime(today.year, today.month, today.day);
  final points = <ChartPoint>[];
  for (var i = days - 1; i >= 0; i--) {
    final day = anchor.subtract(Duration(days: i));
    points.add(ChartPoint(date: day, value: (buckets[dateKey(day)] ?? 0).toDouble()));
  }
  return points;
}
