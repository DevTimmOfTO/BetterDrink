import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/achievement.dart';
import '../services/achievement_service.dart';

/// Holds the set of unlocked achievement ids, keeping it in sync with
/// on-device persistence.
class AchievementNotifier extends Notifier<Set<AchievementId>> {
  @override
  Set<AchievementId> build() {
    _load();
    return const {};
  }

  Future<void> _load() async {
    state = await AchievementService.instance.loadUnlocked();
  }

  /// Evaluates achievement rules against the given stats, unlocking any
  /// newly-earned achievements and updating state. Returns just the
  /// newly-unlocked ones so callers can show unlock feedback.
  Future<List<AchievementId>> checkForNewUnlocks({
    required int currentStreak,
    required int bestStreak,
    required int goalHitDays,
    required int totalDrinksLogged,
  }) async {
    final newlyUnlocked = await AchievementService.instance.checkAndUnlock(
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      goalHitDays: goalHitDays,
      totalDrinksLogged: totalDrinksLogged,
    );
    if (newlyUnlocked.isNotEmpty) {
      state = {...state, ...newlyUnlocked};
    }
    return newlyUnlocked;
  }
}

final achievementProvider =
    NotifierProvider<AchievementNotifier, Set<AchievementId>>(
  AchievementNotifier.new,
);
