/// A friend's shared streak snapshot, imported via a streak-share code and
/// stored locally for comparison. A point-in-time copy, not live data —
/// see [importedAt] for when it was captured.
class FriendSnapshot {
  const FriendSnapshot({
    required this.id,
    required this.displayName,
    required this.currentStreak,
    required this.bestStreak,
    required this.importedAt,
  });

  final String id;
  final String displayName;
  final int currentStreak;
  final int bestStreak;
  final DateTime importedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'currentStreak': currentStreak,
        'bestStreak': bestStreak,
        'importedAt': importedAt.millisecondsSinceEpoch,
      };

  factory FriendSnapshot.fromJson(Map<String, dynamic> json) => FriendSnapshot(
        id: json['id'] as String,
        displayName: json['displayName'] as String,
        currentStreak: json['currentStreak'] as int,
        bestStreak: json['bestStreak'] as int,
        importedAt: DateTime.fromMillisecondsSinceEpoch(json['importedAt'] as int),
      );
}
