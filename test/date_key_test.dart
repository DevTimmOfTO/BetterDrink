import 'package:betterdrink/services/date_key.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formats a date as zero-padded YYYY-MM-DD', () {
    expect(dateKey(DateTime(2026, 1, 5)), '2026-01-05');
    expect(dateKey(DateTime(2026, 12, 31)), '2026-12-31');
  });

  test('ignores the time-of-day component', () {
    expect(dateKey(DateTime(2026, 3, 7, 23, 59)), '2026-03-07');
  });
}
