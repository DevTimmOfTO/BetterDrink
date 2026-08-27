import 'package:betterdrink/services/streak_code.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('encodeStreakCode/decodeStreakCode round-trips a snapshot', () {
    final asOf = DateTime(2026, 1, 1, 12, 30);
    final code = encodeStreakCode(
      displayName: 'Alex',
      currentStreak: 5,
      bestStreak: 12,
      asOf: asOf,
    );
    final decoded = decodeStreakCode(code);

    expect(decoded, isNotNull);
    expect(decoded!.displayName, 'Alex');
    expect(decoded.currentStreak, 5);
    expect(decoded.bestStreak, 12);
    expect(decoded.asOf, asOf);
  });

  test('decodeStreakCode trims surrounding whitespace', () {
    final code = encodeStreakCode(
      displayName: 'Sam',
      currentStreak: 1,
      bestStreak: 1,
      asOf: DateTime(2026, 1, 1),
    );
    final decoded = decodeStreakCode('  $code\n');
    expect(decoded, isNotNull);
    expect(decoded!.displayName, 'Sam');
  });

  test('decodeStreakCode returns null for garbage input', () {
    expect(decodeStreakCode('not a real code'), isNull);
    expect(decodeStreakCode(''), isNull);
  });

  test('decodeStreakCode returns null for valid base64 that is not JSON', () {
    // Decodes to the plain text "hello world", not JSON.
    expect(decodeStreakCode('aGVsbG8gd29ybGQ='), isNull);
  });
}
