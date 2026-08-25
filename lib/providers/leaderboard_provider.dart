
import 'package:betterdrink/models/leaderboard_state.dart';
import 'package:betterdrink/services/leaderboard_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  Future<void> reload() => _load();
}

final leaderboardProvider = NotifierProvider<LeaderboardNotifier, LeaderboardState>(LeaderboardNotifier.new,);
