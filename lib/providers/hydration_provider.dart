import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/achievement.dart';
import '../services/hydration_service.dart';
import '../services/notification_service.dart';
import 'achievement_provider.dart';
import 'hydration_entries_provider.dart';
import 'leaderboard_provider.dart';

/// Holds the next scheduled reminder time, keeping the notification
/// schedule in sync with the UI. Today's total and history live in
/// [hydrationEntriesProvider] / [hydrationHistoryProvider] instead, since
/// they're derived from the logged entries rather than tracked here.
class HydrationNotifier extends Notifier<DateTime?> {
  @override
  DateTime? build() {
    _load();
    return null;
  }

  Future<void> _load() async {
    state = await NotificationService.instance.ensureScheduled();
  }

  /// Logs a drink, restarts the countdown to the next reminder, and checks
  /// for newly-earned achievements. Returns any achievements unlocked by
  /// this log so the UI can show unlock feedback.
  Future<List<AchievementId>> logDrink(int ml) async {
    await ref.read(hydrationEntriesProvider.notifier).addEntry(ml);
    state = await NotificationService.instance.rescheduleFromNow();
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

final hydrationProvider = NotifierProvider<HydrationNotifier, DateTime?>(
  HydrationNotifier.new,
);
