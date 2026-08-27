import 'package:shared_preferences/shared_preferences.dart';

import '../models/achievement.dart';
import 'achievement_rules.dart';

/// Persists which achievements have been unlocked. Stateless like
/// [SettingsService] — reads fresh from [SharedPreferences] on every call
/// rather than caching in memory, so there's no load-before-use ordering
/// requirement for callers.
class AchievementService {
  AchievementService._();
  static final AchievementService instance = AchievementService._();

  static const _keyUnlocked = 'achievements_unlocked';

  Future<Set<AchievementId>> loadUnlocked() async {
    final prefs = await SharedPreferences.getInstance();
    final storedIds = prefs.getStringList(_keyUnlocked) ?? const [];
    final byName = AchievementId.values.asNameMap();
    return storedIds.map((id) => byName[id]).whereType<AchievementId>().toSet();
  }

  /// Evaluates achievement rules against the given stats, persists any
  /// newly-unlocked achievements, and returns just the newly-unlocked ones.
  Future<List<AchievementId>> checkAndUnlock({
    required int currentStreak,
    required int bestStreak,
    required int goalHitDays,
    required int totalDrinksLogged,
  }) async {
    final alreadyUnlocked = await loadUnlocked();
    final shouldBeUnlocked = evaluateAchievements(
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      goalHitDays: goalHitDays,
      totalDrinksLogged: totalDrinksLogged,
    );
    final newlyUnlocked =
        shouldBeUnlocked.difference(alreadyUnlocked).toList(growable: false);
    if (newlyUnlocked.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final updated = {...alreadyUnlocked, ...shouldBeUnlocked};
      await prefs.setStringList(
        _keyUnlocked,
        updated.map((id) => id.name).toList(),
      );
    }
    return newlyUnlocked;
  }
}
