import 'package:shared_preferences/shared_preferences.dart';

/// Persists today's hydration total and the next scheduled reminder time,
/// resetting the daily total automatically when a new day starts.
class HydrationService {
  HydrationService._();
  static final HydrationService instance = HydrationService._();

  static const _keyTodayMl = 'hydration_today_ml';
  static const _keyLastResetDate = 'hydration_last_reset_date';
  static const _keyNextReminderAt = 'hydration_next_reminder_at';

  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  Future<int> loadTodayMl() async {
    final prefs = await SharedPreferences.getInstance();
    await _resetIfNewDay(prefs);
    return prefs.getInt(_keyTodayMl) ?? 0;
  }

  /// Adds [ml] to today's total, resetting the total first if the stored
  /// value is from a previous day. Returns the new total.
  Future<int> logDrink(int ml) async {
    final prefs = await SharedPreferences.getInstance();
    await _resetIfNewDay(prefs);
    final updated = (prefs.getInt(_keyTodayMl) ?? 0) + ml;
    await prefs.setInt(_keyTodayMl, updated);
    return updated;
  }

  Future<void> _resetIfNewDay(SharedPreferences prefs) async {
    final today = _dateKey(DateTime.now());
    if (prefs.getString(_keyLastResetDate) != today) {
      await prefs.setInt(_keyTodayMl, 0);
      await prefs.setString(_keyLastResetDate, today);
    }
  }

  Future<DateTime?> loadNextReminderAt() async {
    final prefs = await SharedPreferences.getInstance();
    final millis = prefs.getInt(_keyNextReminderAt);
    return millis == null ? null : DateTime.fromMillisecondsSinceEpoch(millis);
  }

  Future<void> saveNextReminderAt(DateTime at) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyNextReminderAt, at.millisecondsSinceEpoch);
  }
}
