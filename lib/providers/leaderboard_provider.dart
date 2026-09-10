
import 'package:betterdrink/models/leaderboard_state.dart';
import 'package:betterdrink/services/leaderboard_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the current/best drink-logging streak as a snapshot of
/// [LeaderboardService]'s state.
///
/// Unlike the other services, [LeaderboardService] caches streak state in
/// mutable instance fields rather than recomputing from `shared_preferences`
/// on every read, so this notifier doesn't own the data itself -- it just
/// mirrors whatever [LeaderboardService.load] last populated. The streak is
/// actually advanced elsewhere, by `LeaderboardService.recordDrink()` inside
/// `HydrationService.logDrink`; other notifiers that trigger a drink log
/// (e.g. `HydrationNotifier.logDrink`) call [reload] afterwards so this
/// provider's state catches up with that change.
class LeaderboardNotifier extends Notifier<LeaderboardState> {
  @override
  LeaderboardState build() {
    _load();
    return LeaderboardState(currentStreak: 0, bestStreak: 0);
  }

  Future<void> _load() async {
    await LeaderboardService.instance.load();
    state = LeaderboardState(
      currentStreak: LeaderboardService.instance.currentStreak,
      bestStreak: LeaderboardService.instance.bestStreak,
    );
  }

  /// Re-runs [_load] to pick up streak changes recorded elsewhere (e.g.
  /// via `LeaderboardService.recordDrink()` after logging a drink).
  Future<void> reload() => _load();
}

final leaderboardProvider = NotifierProvider<LeaderboardNotifier, LeaderboardState>(LeaderboardNotifier.new,);
