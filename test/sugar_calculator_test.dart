import 'package:betterdrink/models/sugar_entry.dart';
import 'package:betterdrink/services/history_aggregator.dart';
import 'package:betterdrink/services/sugar_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('gramsOfSugar computes grams from volume and sugar concentration', () {
    final grams = gramsOfSugar(volumeMl: 330, sugarPer100ml: 10.6);
    expect(grams, closeTo(34.98, 0.001));
  });

  test('bucketSugarByDay sums grams of sugar for drinks on the same day', () {
    final drinks = [
      SugarEntry(
        id: '1',
        name: 'Cola',
        volumeMl: 330,
        sugarPer100ml: 10.6,
        timestamp: DateTime(2026, 1, 1, 9),
      ),
      SugarEntry(
        id: '2',
        name: 'Lemonade',
        volumeMl: 330,
        sugarPer100ml: 9,
        timestamp: DateTime(2026, 1, 1, 15),
      ),
      SugarEntry(
        id: '3',
        name: 'Cola',
        volumeMl: 330,
        sugarPer100ml: 10.6,
        timestamp: DateTime(2026, 1, 2, 9),
      ),
    ];

    final buckets = bucketSugarByDay(drinks);

    expect(buckets['2026-01-01'], closeTo(34.98 + 29.7, 0.001));
    expect(buckets['2026-01-02'], closeTo(34.98, 0.001));
  });
}
