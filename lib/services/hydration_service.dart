import 'dart:convert';

import 'package:betterdrink/services/date_key.dart';
import 'package:betterdrink/services/leaderboard_service.dart';
import 'package:betterdrink/services/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists today's hydration total and the next scheduled reminder time,
/// resetting the daily total automatically when a new day starts.
class HydrationService {
  HydrationService._();
  static final HydrationService instance = HydrationService._();

  static const _keyTodayMl = 'hydration_today_ml';
  static const _keyLastResetDate = 'hydration_last_reset_date';
  static const _keyNextReminderAt = 'hydration_next_reminder_at';
  static const _keyGoalHitDays = 'settings_goal_hit_days';
  static const _keyTotalDrinksLogged = 'hydration_total_drinks_logged';
  static const _keyHistory = 'hydration_history';

  /// Day-bucketed totals older than this no longer affect the trend chart,
  /// so they're dropped instead of growing the history forever.
  static const _historyRetention = Duration(days: 90);

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
    await LeaderboardService.instance.recordDrink();
    await prefs.setInt(_keyTodayMl, updated);
    final totalLogged = (prefs.getInt(_keyTotalDrinksLogged) ?? 0) + 1;
    await prefs.setInt(_keyTotalDrinksLogged, totalLogged);
    return updated;
  }

  /// Goal-hit day count and lifetime drink-log count, used by
  /// [AchievementService] to evaluate achievement thresholds.
  Future<({int goalHitDays, int totalDrinksLogged})> loadGoalStats() async {
    final prefs = await SharedPreferences.getInstance();
    return (
      goalHitDays: prefs.getInt(_keyGoalHitDays) ?? 0,
      totalDrinksLogged: prefs.getInt(_keyTotalDrinksLogged) ?? 0,
    );
  }

  /// Day-bucketed hydration totals (date key -> ml), pruned to the last
  /// [_historyRetention], for the Trends chart on the Home tab.
  Future<Map<String, int>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return _pruneHistory(await _readHistory(prefs));
  }

  Future<Map<String, int>> _readHistory(SharedPreferences prefs) async {
    final raw = prefs.getString(_keyHistory);
    if (raw == null) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map((key, value) => MapEntry(key, value as int));
  }

  Map<String, int> _pruneHistory(Map<String, int> history) {
    final cutoffKey = dateKey(DateTime.now().subtract(_historyRetention));
    return {
      for (final entry in history.entries)
        if (entry.key.compareTo(cutoffKey) >= 0) entry.key: entry.value,
    };
  }

  Future<void> _resetIfNewDay(SharedPreferences prefs) async {
    final today = dateKey(DateTime.now());
    final lastResetDate = prefs.getString(_keyLastResetDate);
    if (lastResetDate != today) {
      final finishedDayMl = prefs.getInt(_keyTodayMl) ?? 0;

      if (lastResetDate != null) {
        final history = _pruneHistory(await _readHistory(prefs));
        history[lastResetDate] = finishedDayMl;
        await prefs.setString(_keyHistory, jsonEncode(history));
      }

      final goalMl = (await SettingsService.instance.load()).dailyGoalMl;
      if (finishedDayMl >= goalMl) {
        final hits = prefs.getInt(_keyGoalHitDays) ?? 0;
        await prefs.setInt(_keyGoalHitDays, hits + 1);
      }
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
