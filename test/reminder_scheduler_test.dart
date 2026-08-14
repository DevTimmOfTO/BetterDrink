import 'package:betterdrink/services/reminder_scheduler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const activeStart = 8 * 60; // 08:00
  const activeEnd = 22 * 60; // 22:00

  test('keeps the reminder when it lands inside the active window', () {
    final from = DateTime(2026, 1, 1, 10, 0);
    final next = computeNextReminder(
      from: from,
      intervalMinutes: 45,
      activeStartMinutes: activeStart,
      activeEndMinutes: activeEnd,
    );
    expect(next, DateTime(2026, 1, 1, 10, 45));
  });

  test('pushes a late-night reminder to the next active window start', () {
    // 21:30 + 60 minutes = 22:30, which is past the 22:00 cutoff.
    final from = DateTime(2026, 1, 1, 21, 30);
    final next = computeNextReminder(
      from: from,
      intervalMinutes: 60,
      activeStartMinutes: activeStart,
      activeEndMinutes: activeEnd,
    );
    expect(next, DateTime(2026, 1, 2, 8, 0));
  });

  test('pushes an early-morning reminder up to the active window start', () {
    // Simulates the app being opened at 3am after being closed overnight.
    final from = DateTime(2026, 1, 1, 3, 0);
    final next = computeNextReminder(
      from: from,
      intervalMinutes: 30,
      activeStartMinutes: activeStart,
      activeEndMinutes: activeEnd,
    );
    expect(next, DateTime(2026, 1, 1, 8, 0));
  });

  test('treats the active end boundary as exclusive', () {
    final from = DateTime(2026, 1, 1, 21, 0);
    final next = computeNextReminder(
      from: from,
      intervalMinutes: 60,
      activeStartMinutes: activeStart,
      activeEndMinutes: activeEnd,
    );
    expect(next, DateTime(2026, 1, 2, 8, 0));
  });
}
