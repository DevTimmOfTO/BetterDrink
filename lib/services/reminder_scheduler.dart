/// Computes the next reminder time by adding [intervalMinutes] to [from],
/// then pushing the result into the `[activeStartMinutes, activeEndMinutes)`
/// window (minutes since midnight) if it would otherwise land outside it.
///
/// Assumes `activeStartMinutes < activeEndMinutes`, i.e. a same-day waking
/// window such as 8:00-22:00 rather than one that wraps past midnight.
DateTime computeNextReminder({
  required DateTime from,
  required int intervalMinutes,
  required int activeStartMinutes,
  required int activeEndMinutes,
}) {
  final candidate = from.add(Duration(minutes: intervalMinutes));
  return _clampToActiveWindow(candidate, activeStartMinutes, activeEndMinutes);
}

DateTime _clampToActiveWindow(
  DateTime candidate,
  int activeStartMinutes,
  int activeEndMinutes,
) {
  final candidateMinutes = candidate.hour * 60 + candidate.minute;
  if (candidateMinutes < activeStartMinutes) {
    return _atMinutesOfDay(candidate, activeStartMinutes);
  }
  if (candidateMinutes >= activeEndMinutes) {
    final nextDay = candidate.add(const Duration(days: 1));
    return _atMinutesOfDay(nextDay, activeStartMinutes);
  }
  return candidate;
}

DateTime _atMinutesOfDay(DateTime day, int minutesOfDay) {
  return DateTime(
    day.year,
    day.month,
    day.day,
    minutesOfDay ~/ 60,
    minutesOfDay % 60,
  );
}

/// Computes the next [count] reminder times, each chained off the previous
/// one via [computeNextReminder]. Scheduling all of them with the OS up
/// front (rather than just the next one) means the reminder series keeps
/// firing on its own even if a given notification is missed or dismissed
/// without the app being reopened -- see GitHub issue #8.
List<DateTime> computeReminderBatch({
  required DateTime from,
  required int intervalMinutes,
  required int activeStartMinutes,
  required int activeEndMinutes,
  required int count,
}) {
  final times = <DateTime>[];
  var current = from;
  for (var i = 0; i < count; i++) {
    current = computeNextReminder(
      from: current,
      intervalMinutes: intervalMinutes,
      activeStartMinutes: activeStartMinutes,
      activeEndMinutes: activeEndMinutes,
    );
    times.add(current);
  }
  return times;
}
