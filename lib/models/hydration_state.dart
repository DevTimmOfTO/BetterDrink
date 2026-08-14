/// Today's hydration progress: how much has been logged, and when the
/// next reminder is scheduled to fire.
class HydrationState {
  const HydrationState({
    required this.todayMl,
    required this.nextReminderAt,
  });

  static const HydrationState initial = HydrationState(
    todayMl: 0,
    nextReminderAt: null,
  );

  final int todayMl;
  final DateTime? nextReminderAt;

  HydrationState copyWith({int? todayMl, DateTime? nextReminderAt}) {
    return HydrationState(
      todayMl: todayMl ?? this.todayMl,
      nextReminderAt: nextReminderAt ?? this.nextReminderAt,
    );
  }
}
