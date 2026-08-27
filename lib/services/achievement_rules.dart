import '../models/achievement.dart';

/// Determines which achievements should be unlocked given the current
/// hydration/streak stats. Pure and side-effect free so it can be unit
/// tested without touching persistence.
Set<AchievementId> evaluateAchievements({
  required int currentStreak,
  required int bestStreak,
  required int goalHitDays,
  required int totalDrinksLogged,
}) {
  final longestStreak = currentStreak > bestStreak ? currentStreak : bestStreak;
  final unlocked = <AchievementId>{};
  if (longestStreak >= 3) unlocked.add(AchievementId.streak3);
  if (longestStreak >= 7) unlocked.add(AchievementId.streak7);
  if (longestStreak >= 30) unlocked.add(AchievementId.streak30);
  if (goalHitDays >= 5) unlocked.add(AchievementId.goalHit5);
  if (goalHitDays >= 30) unlocked.add(AchievementId.goalHit30);
  if (totalDrinksLogged >= 50) unlocked.add(AchievementId.drinksLogged50);
  return unlocked;
}
