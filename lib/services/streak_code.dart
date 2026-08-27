import 'dart:convert';

/// Decoded payload of a streak-share code — see [encodeStreakCode].
class StreakSnapshot {
  const StreakSnapshot({
    required this.displayName,
    required this.currentStreak,
    required this.bestStreak,
    required this.asOf,
  });

  final String displayName;
  final int currentStreak;
  final int bestStreak;
  final DateTime asOf;
}

/// Packs a streak snapshot into a compact, copyable text code the user can
/// share through any channel outside the app (chat, SMS, ...). Purely
/// local encoding — nothing here makes a network call.
String encodeStreakCode({
  required String displayName,
  required int currentStreak,
  required int bestStreak,
  required DateTime asOf,
}) {
  final json = jsonEncode({
    'n': displayName,
    'c': currentStreak,
    'b': bestStreak,
    't': asOf.millisecondsSinceEpoch,
  });
  return base64Url.encode(utf8.encode(json));
}

/// Inverse of [encodeStreakCode]. Returns null — never throws — on
/// malformed input, so callers can show a friendly error instead of
/// crashing on a mistyped or garbled code.
StreakSnapshot? decodeStreakCode(String code) {
  try {
    final json = utf8.decode(base64Url.decode(code.trim()));
    final decoded = jsonDecode(json) as Map<String, dynamic>;
    return StreakSnapshot(
      displayName: decoded['n'] as String,
      currentStreak: decoded['c'] as int,
      bestStreak: decoded['b'] as int,
      asOf: DateTime.fromMillisecondsSinceEpoch(decoded['t'] as int),
    );
  } catch (_) {
    return null;
  }
}
