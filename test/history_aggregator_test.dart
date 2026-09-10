import 'package:betterdrink/models/beverage_kind.dart';
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

    test('credits coffee and tea below their poured volume', () {
      final entries = [
        WaterEntry(
          id: '1',
          volumeMl: 250,
          timestamp: DateTime(2026, 1, 1, 8),
          kind: BeverageKind.coffee,
        ),
        WaterEntry(
          id: '2',
          volumeMl: 200,
          timestamp: DateTime(2026, 1, 1, 10),
          kind: BeverageKind.tea,
        ),
        WaterEntry(id: '3', volumeMl: 500, timestamp: DateTime(2026, 1, 1, 14)),
      ];
      // 250 * 0.8 + 200 * 0.9 + 500 * 1.0
      expect(bucketWaterByDay(entries), {'2026-01-01': 880});
    });
  });

  group('BeverageKind', () {
    test('water is credited at its full volume', () {
      expect(BeverageKind.water.hydrationMl(500), 500);
    });

    test('rounds the credited volume to whole ml', () {
      // 125 * 0.8 = 100 exactly; 175 * 0.9 = 157.5 rounds up.
      expect(BeverageKind.coffee.hydrationMl(125), 100);
      expect(BeverageKind.tea.hydrationMl(175), 158);
    });

    test('falls back to water for entries stored before drink kinds', () {
      expect(BeverageKind.fromStorageKey(null), BeverageKind.water);
      expect(BeverageKind.fromStorageKey('nonsense'), BeverageKind.water);
      expect(BeverageKind.fromStorageKey('coffee'), BeverageKind.coffee);
    });

    test('round-trips through JSON', () {
      final entry = WaterEntry(
        id: '1',
        volumeMl: 125,
        timestamp: DateTime(2026, 1, 1, 8),
        kind: BeverageKind.tea,
      );
      final restored = WaterEntry.fromJson(entry.toJson());
      expect(restored.kind, BeverageKind.tea);
      expect(restored.volumeMl, 125);
      expect(restored.timestamp, entry.timestamp);
    });

    test('an entry logged before drink kinds decodes as water', () {
      final legacy = {
        'id': '1',
        'volumeMl': 250,
        'timestamp': DateTime(2026, 1, 1, 8).millisecondsSinceEpoch,
      };
      final restored = WaterEntry.fromJson(legacy);
      expect(restored.kind, BeverageKind.water);
      expect(restored.hydrationMl, 250);
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
