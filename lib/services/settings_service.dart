import 'package:shared_preferences/shared_preferences.dart';

import '../models/reminder_settings.dart';

/// Persists [ReminderSettings] to on-device storage via shared_preferences.
class SettingsService {
  SettingsService._();
  static final SettingsService instance = SettingsService._();

  static const _keyInterval = 'settings_interval_minutes';
  static const _keyActiveStart = 'settings_active_start_minutes';
  static const _keyActiveEnd = 'settings_active_end_minutes';
  static const _keyMessage = 'settings_message';
  static const _keyDailyGoalMl = 'settings_daily_goal_ml';

  Future<ReminderSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return ReminderSettings(
      intervalMinutes:
          prefs.getInt(_keyInterval) ?? ReminderSettings.defaults.intervalMinutes,
      activeStartMinutes: prefs.getInt(_keyActiveStart) ??
          ReminderSettings.defaults.activeStartMinutes,
      activeEndMinutes: prefs.getInt(_keyActiveEnd) ??
          ReminderSettings.defaults.activeEndMinutes,
      message: prefs.getString(_keyMessage) ?? ReminderSettings.defaults.message,
      dailyGoalMl: prefs.getInt(_keyDailyGoalMl) ??
          ReminderSettings.defaults.dailyGoalMl,
    );
  }

  Future<void> save(ReminderSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyInterval, settings.intervalMinutes);
    await prefs.setInt(_keyActiveStart, settings.activeStartMinutes);
    await prefs.setInt(_keyActiveEnd, settings.activeEndMinutes);
    await prefs.setString(_keyMessage, settings.message);
    await prefs.setInt(_keyDailyGoalMl, settings.dailyGoalMl);
  }
}
