import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/achievement.dart';
import '../models/hydration_state.dart';
import '../services/hydration_service.dart';
import '../services/notification_service.dart';
import 'achievement_provider.dart';
import 'hydration_history_provider.dart';
import 'leaderboard_provider.dart';

/// Holds today's hydration total and the next reminder time, keeping
/// persistence and the notification schedule in sync with the UI.
class HydrationNotifier extends Notifier<HydrationState> {
  @override
  HydrationState build() {
    _load();
    return HydrationState.initial;
  }

  Future<void> _load() async {
    final todayMl = await HydrationService.instance.loadTodayMl();
    final next = await NotificationService.instance.ensureScheduled();
    state = HydrationState(todayMl: todayMl, nextReminderAt: next);
    await ref.read(hydrationHistoryProvider.notifier).reload();
  }

  /// Logs a drink, restarts the countdown to the next reminder, and checks
  /// for newly-earned achievements. Returns any achievements unlocked by
  /// this log so the UI can show unlock feedback.
  Future<List<AchievementId>> logDrink(int ml) async {
    final updated = await HydrationService.instance.logDrink(ml);
    final next = await NotificationService.instance.rescheduleFromNow();
    state = state.copyWith(todayMl: updated, nextReminderAt: next);
    await ref.read(leaderboardProvider.notifier).reload();

    final leaderboard = ref.read(leaderboardProvider);
    final stats = await HydrationService.instance.loadGoalStats();
    return ref.read(achievementProvider.notifier).checkForNewUnlocks(
          currentStreak: leaderboard.currentStreak,
          bestStreak: leaderboard.bestStreak,
          goalHitDays: stats.goalHitDays,
          totalDrinksLogged: stats.totalDrinksLogged,
        );
  }
}

final hydrationProvider = NotifierProvider<HydrationNotifier, HydrationState>(
  HydrationNotifier.new,
);
