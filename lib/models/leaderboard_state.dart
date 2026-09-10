/// Streak counters shown on the Leaderboard tab. Kept as a plain snapshot
/// here — the stateful bookkeeping (loading, mutating, persisting) lives in
/// `LeaderboardService`, not this model.
class LeaderboardState {
  const LeaderboardState({required this.currentStreak, required this.bestStreak});
  final int currentStreak;
  final int bestStreak;
}
