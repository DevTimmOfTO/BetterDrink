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
