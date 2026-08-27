/// User-configurable hydration reminder settings, persisted via
/// [SettingsService].
class ReminderSettings {
  const ReminderSettings({
    required this.intervalMinutes,
    required this.activeStartMinutes,
    required this.activeEndMinutes,
    required this.message,
    required this.dailyGoalMl,
  });

  static const ReminderSettings defaults = ReminderSettings(
    intervalMinutes: 60,
    activeStartMinutes: 8 * 60,
    activeEndMinutes: 22 * 60,
    message: 'Time to drink some water 💧',
    dailyGoalMl: 2000,
  );

  /// How often a reminder should fire, in minutes.
  final int intervalMinutes;

  /// Start of the daily window in which reminders are allowed to fire,
  /// expressed as minutes since midnight (e.g. 8:00 -> 480).
  final int activeStartMinutes;

  /// End of the daily window in which reminders are allowed to fire,
  /// expressed as minutes since midnight (e.g. 22:00 -> 1320).
  final int activeEndMinutes;

  /// The body text shown in the reminder notification.
  final String message;

  /// Daily hydration goal, in millilitres, used to track goal-hit
  /// achievements.
  final int dailyGoalMl;

  ReminderSettings copyWith({
    int? intervalMinutes,
    int? activeStartMinutes,
    int? activeEndMinutes,
    String? message,
    int? dailyGoalMl,
  }) {
    return ReminderSettings(
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      activeStartMinutes: activeStartMinutes ?? this.activeStartMinutes,
      activeEndMinutes: activeEndMinutes ?? this.activeEndMinutes,
      message: message ?? this.message,
      dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
    );
  }
}
