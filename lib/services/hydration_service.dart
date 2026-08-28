import 'dart:convert';

import 'package:betterdrink/services/date_key.dart';
import 'package:betterdrink/services/leaderboard_service.dart';
import 'package:betterdrink/services/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/water_entry.dart';

/// Persists logged water entries and the next scheduled reminder time.
/// Today's total and day-bucketed history are derived from the entry list
/// rather than tracked separately (see [HydrationEntriesNotifier] and
/// `bucketWaterByDay`).
class HydrationService {
  HydrationService._();
  static final HydrationService instance = HydrationService._();

  static const _keyEntries = 'hydration_entries';
  static const _keyLastResetDate = 'hydration_last_reset_date';
  static const _keyNextReminderAt = 'hydration_next_reminder_at';
  static const _keyGoalHitDays = 'settings_goal_hit_days';
  static const _keyTotalDrinksLogged = 'hydration_total_drinks_logged';

  /// Pre-#1 storage keys: a single cumulative today total plus a
  /// day-bucketed history map, with no per-entry detail. Migrated into
  /// synthetic entries the first time [loadEntries] runs after upgrading,
  /// so upgrading doesn't silently drop existing history.
  static const _keyLegacyTodayMl = 'hydration_today_ml';
  static const _keyLegacyHistory = 'hydration_history';

  /// Entries older than this no longer affect the trend chart, so they're
  /// dropped on load instead of growing the history forever.
  static const _historyRetention = Duration(days: 30);

  Future<List<WaterEntry>> loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await _readEntries(prefs);
    await _checkGoalOnDayChange(prefs, entries);
    final cutoff = DateTime.now().subtract(_historyRetention);
    return entries.where((e) => e.timestamp.isAfter(cutoff)).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<void> saveEntries(List<WaterEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _keyEntries,
      entries.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  /// Adds an entry of [ml] logged now, records it toward the streak and
  /// lifetime drink count, and returns the updated entry list.
  Future<List<WaterEntry>> logDrink(int ml) async {
    final entries = await loadEntries();
    final entry = WaterEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      volumeMl: ml,
      timestamp: DateTime.now(),
    );
    final updated = [entry, ...entries]
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    await saveEntries(updated);
    await LeaderboardService.instance.recordDrink();

    final prefs = await SharedPreferences.getInstance();
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

  Future<List<WaterEntry>> _readEntries(SharedPreferences prefs) async {
    final raw = prefs.getStringList(_keyEntries);
    if (raw == null) return _migrateLegacyData(prefs);
    return raw
        .map((e) => WaterEntry.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList();
  }

  Future<List<WaterEntry>> _migrateLegacyData(SharedPreferences prefs) async {
    final entries = <WaterEntry>[];
    final historyRaw = prefs.getString(_keyLegacyHistory);
    if (historyRaw != null) {
      final history = jsonDecode(historyRaw) as Map<String, dynamic>;
      history.forEach((day, ml) {
        final volume = (ml as num).toInt();
        if (volume > 0) {
          entries.add(WaterEntry(
            id: 'migrated_$day',
            volumeMl: volume,
            timestamp: _middayOf(day),
          ));
        }
      });
    }
    final legacyTodayMl = prefs.getInt(_keyLegacyTodayMl) ?? 0;
    if (legacyTodayMl > 0) {
      entries.add(WaterEntry(
        id: 'migrated_today',
        volumeMl: legacyTodayMl,
        timestamp: DateTime.now(),
      ));
    }
    await prefs.remove(_keyLegacyTodayMl);
    await prefs.remove(_keyLegacyHistory);
    await prefs.setStringList(
      _keyEntries,
      entries.map((e) => jsonEncode(e.toJson())).toList(),
    );
    return entries;
  }

  DateTime _middayOf(String dayKey) {
    final parts = dayKey.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
      12,
    );
  }

  /// Once per calendar day, checks whether the previous day's total (summed
  /// from [entries]) hit the daily goal and, if so, credits it toward the
  /// goal-hit achievement counter. Deferred like this — run lazily whenever
  /// entries are touched — rather than on a timer, since there's no
  /// background scheduling for plain persistence checks.
  Future<void> _checkGoalOnDayChange(
    SharedPreferences prefs,
    List<WaterEntry> entries,
  ) async {
    final today = dateKey(DateTime.now());
    final lastCheckedDate = prefs.getString(_keyLastResetDate);
    if (lastCheckedDate == today) return;

    if (lastCheckedDate != null) {
      final finishedDayMl = entries
          .where((e) => dateKey(e.timestamp) == lastCheckedDate)
          .fold<int>(0, (sum, e) => sum + e.volumeMl);
      final goalMl = (await SettingsService.instance.load()).dailyGoalMl;
      if (finishedDayMl >= goalMl) {
        final hits = prefs.getInt(_keyGoalHitDays) ?? 0;
        await prefs.setInt(_keyGoalHitDays, hits + 1);
      }
    }
    await prefs.setString(_keyLastResetDate, today);
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
