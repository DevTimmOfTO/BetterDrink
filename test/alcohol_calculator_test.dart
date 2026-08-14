import 'package:betterdrink/models/drink_entry.dart';
import 'package:betterdrink/models/user_profile.dart';
import 'package:betterdrink/services/alcohol_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const profile = UserProfile(sex: Sex.male, age: 30, weightKg: 80);

  test('gramsOfAlcohol computes grams from volume and ABV', () {
    final grams = gramsOfAlcohol(volumeMl: 500, abvPercent: 5);
    expect(grams, closeTo(19.725, 0.001));
  });

  test('estimateBac at the moment of a single drink equals the peak', () {
    final drink = DrinkEntry(
      id: '1',
      name: 'Beer',
      volumeMl: 500,
      abvPercent: 5,
      timestamp: DateTime(2026, 1, 1, 20),
    );
    final grams = gramsOfAlcohol(volumeMl: 500, abvPercent: 5);
    final expectedPeak = grams / (80 * widmarkFactor(Sex.male));

    final bac = estimateBac(
      drinks: [drink],
      at: drink.timestamp,
      profile: profile,
    );
    expect(bac, closeTo(expectedPeak, 0.0001));
  });

  test('estimateBac decays to zero once fully eliminated', () {
    final drink = DrinkEntry(
      id: '1',
      name: 'Beer',
      volumeMl: 330,
      abvPercent: 5,
      timestamp: DateTime(2026, 1, 1, 20),
    );
    final bac = estimateBac(
      drinks: [drink],
      at: drink.timestamp.add(const Duration(hours: 24)),
      profile: profile,
    );
    expect(bac, 0);
  });

  test('estimateBac sums contributions from multiple drinks', () {
    final first = DrinkEntry(
      id: '1',
      name: 'Beer',
      volumeMl: 500,
      abvPercent: 5,
      timestamp: DateTime(2026, 1, 1, 20),
    );
    final second = DrinkEntry(
      id: '2',
      name: 'Beer',
      volumeMl: 500,
      abvPercent: 5,
      timestamp: DateTime(2026, 1, 1, 20, 30),
    );
    final at = DateTime(2026, 1, 1, 20, 30);

    final combined = estimateBac(drinks: [first, second], profile: profile, at: at);
    final firstAlone = estimateBac(drinks: [first], profile: profile, at: at);
    final secondAlone = estimateBac(drinks: [second], profile: profile, at: at);

    expect(combined, closeTo(firstAlone + secondAlone, 0.0001));
  });

  test('timeToZeroBac returns zero for non-positive BAC', () {
    expect(timeToZeroBac(0), Duration.zero);
    expect(timeToZeroBac(-1), Duration.zero);
  });

  test('timeToZeroBac converts BAC to hours at the elimination rate', () {
    final duration = timeToZeroBac(0.3);
    expect(duration.inMinutes, closeTo(120, 1));
  });
}
