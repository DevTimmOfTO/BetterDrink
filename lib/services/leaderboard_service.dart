import 'package:shared_preferences/shared_preferences.dart';

class LeaderboardService {
  LeaderboardService._();
  static final LeaderboardService instance = LeaderboardService._();

  static const _keyCurrentStreak = 'streak_current';
  static const _keyBestStreak = 'streak_best';
  static const _keyLastDate = 'streak_last_date';

  // in-memory fields — like C# properties, live while app is running
  int currentStreak = 0;
  int bestStreak = 0;
  String lastDate = '';

  String _today() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  String _yesterday() {
    final y = DateTime.now().subtract(const Duration(days: 1));
    return '${y.year}-${y.month.toString().padLeft(2, '0')}-${y.day.toString().padLeft(2, '0')}';
  }

  /// Loads streak state from disk into the in-memory fields.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    currentStreak = prefs.getInt(_keyCurrentStreak) ?? 0;
    bestStreak = prefs.getInt(_keyBestStreak) ?? 0;
    lastDate = prefs.getString(_keyLastDate) ?? '';
  }

  /// Saves current in-memory fields back to disk.
  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCurrentStreak, currentStreak);
    await prefs.setInt(_keyBestStreak, bestStreak);
    await prefs.setString(_keyLastDate, lastDate);
  }

  /// Called whenever the user logs a drink. Updates the streak and saves.
  ///
  /// Reloads from disk first: this can run in a fresh background isolate
  /// (the notification's "Drank it" action fires
  /// `notificationBackgroundHandler` when the app process isn't running),
  /// where these in-memory fields default to zero/empty because [load]
  /// was never called in that isolate. Without reloading here, that
  /// confirmation would compute the streak from those defaults and
  /// silently overwrite an existing streak on disk with garbage.
  Future<void> recordDrink() async {
    await load();
    final today = _today();

    if (lastDate == today) {
      // already counted today — do nothing
      return;
    } else if (lastDate == _yesterday()) {
      // drank yesterday too — extend the streak
      currentStreak += 1;
    } else {
      // gap of more than one day — reset
      currentStreak = 1;
    }

    if (currentStreak > bestStreak) bestStreak = currentStreak;
    lastDate = today;
    await _save();
  }
}
