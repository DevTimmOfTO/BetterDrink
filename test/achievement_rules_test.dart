import 'package:betterdrink/models/achievement.dart';
import 'package:betterdrink/services/achievement_rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('unlocks nothing when every stat is below its threshold', () {
    final unlocked = evaluateAchievements(
      currentStreak: 1,
      bestStreak: 1,
      goalHitDays: 0,
      totalDrinksLogged: 1,
    );
    expect(unlocked, isEmpty);
  });

  test('unlocks streak achievements using the higher of current/best streak', () {
    final unlocked = evaluateAchievements(
      currentStreak: 2,
      bestStreak: 7,
      goalHitDays: 0,
      totalDrinksLogged: 0,
    );
    expect(unlocked, {AchievementId.streak3, AchievementId.streak7});
  });

  test('unlocks goal-hit achievements at 5 and 30 days', () {
    final unlocked = evaluateAchievements(
      currentStreak: 0,
      bestStreak: 0,
      goalHitDays: 30,
      totalDrinksLogged: 0,
    );
    expect(unlocked, {AchievementId.goalHit5, AchievementId.goalHit30});
  });

  test('unlocks drinksLogged50 once 50 drinks have been logged', () {
    final below = evaluateAchievements(
      currentStreak: 0,
      bestStreak: 0,
      goalHitDays: 0,
      totalDrinksLogged: 49,
    );
    final at = evaluateAchievements(
      currentStreak: 0,
      bestStreak: 0,
      goalHitDays: 0,
      totalDrinksLogged: 50,
    );
    expect(below.contains(AchievementId.drinksLogged50), isFalse);
    expect(at.contains(AchievementId.drinksLogged50), isTrue);
  });

  test('unlocks everything at once when every threshold is cleared', () {
    final unlocked = evaluateAchievements(
      currentStreak: 30,
      bestStreak: 30,
      goalHitDays: 30,
      totalDrinksLogged: 50,
    );
    expect(unlocked, AchievementId.values.toSet());
  });
}
