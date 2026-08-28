import 'package:betterdrink/models/drink_entry.dart';
import 'package:betterdrink/models/water_entry.dart';
import 'package:betterdrink/services/alcohol_calculator.dart';
import 'package:betterdrink/services/history_aggregator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('bucketWaterByDay', () {
    test('sums ml of water for entries on the same day', () {
      final entries = [
        WaterEntry(id: '1', volumeMl: 250, timestamp: DateTime(2026, 1, 1, 8)),
        WaterEntry(id: '2', volumeMl: 500, timestamp: DateTime(2026, 1, 1, 14)),
      ];
      expect(bucketWaterByDay(entries), {'2026-01-01': 750});
    });

    test('keeps entries on different days in separate buckets', () {
      final entries = [
        WaterEntry(id: '1', volumeMl: 250, timestamp: DateTime(2026, 1, 1, 8)),
        WaterEntry(id: '2', volumeMl: 250, timestamp: DateTime(2026, 1, 2, 8)),
      ];
      expect(bucketWaterByDay(entries).keys, {'2026-01-01', '2026-01-02'});
    });

    test('returns an empty map for no entries', () {
      expect(bucketWaterByDay(const []), isEmpty);
    });
  });

  group('bucketDrinksByDay', () {
    test('sums grams of alcohol for drinks on the same day', () {
      final drinks = [
        DrinkEntry(
          id: '1',
          name: 'Beer',
          volumeMl: 500,
          abvPercent: 5,
          timestamp: DateTime(2026, 1, 1, 20),
        ),
        DrinkEntry(
          id: '2',
          name: 'Wine',
          volumeMl: 150,
          abvPercent: 12,
          timestamp: DateTime(2026, 1, 1, 22),
        ),
      ];
      final buckets = bucketDrinksByDay(drinks);
      final expected = gramsOfAlcohol(volumeMl: 500, abvPercent: 5) +
          gramsOfAlcohol(volumeMl: 150, abvPercent: 12);
      expect(buckets, {'2026-01-01': closeTo(expected, 0.0001)});
    });

    test('keeps drinks on different days in separate buckets', () {
      final drinks = [
        DrinkEntry(
          id: '1',
          name: 'Beer',
          volumeMl: 500,
          abvPercent: 5,
          timestamp: DateTime(2026, 1, 1, 20),
        ),
        DrinkEntry(
          id: '2',
          name: 'Beer',
          volumeMl: 500,
          abvPercent: 5,
          timestamp: DateTime(2026, 1, 2, 20),
        ),
      ];
      final buckets = bucketDrinksByDay(drinks);
      expect(buckets.keys, {'2026-01-01', '2026-01-02'});
    });

    test('returns an empty map for no drinks', () {
      expect(bucketDrinksByDay(const []), isEmpty);
    });
  });

  group('fillMissingDays', () {
    test('returns days days ending today, oldest first', () {
      final points = fillMissingDays(
        const {},
        days: 3,
        now: DateTime(2026, 1, 10),
      );
      expect(points.map((p) => p.date), [
        DateTime(2026, 1, 8),
        DateTime(2026, 1, 9),
        DateTime(2026, 1, 10),
      ]);
    });

    test('fills days with no bucket entry with zero', () {
      final points = fillMissingDays(
        {'2026-01-09': 42.0},
        days: 3,
        now: DateTime(2026, 1, 10),
      );
      expect(points.map((p) => p.value), [0.0, 42.0, 0.0]);
    });
  });
}
