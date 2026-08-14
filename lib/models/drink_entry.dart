/// A single logged alcoholic drink.
class DrinkEntry {
  const DrinkEntry({
    required this.id,
    required this.name,
    required this.volumeMl,
    required this.abvPercent,
    required this.timestamp,
  });

  final String id;
  final String name;
  final double volumeMl;
  final double abvPercent;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'volumeMl': volumeMl,
        'abvPercent': abvPercent,
        'timestamp': timestamp.millisecondsSinceEpoch,
      };

  factory DrinkEntry.fromJson(Map<String, dynamic> json) => DrinkEntry(
        id: json['id'] as String,
        name: json['name'] as String,
        volumeMl: (json['volumeMl'] as num).toDouble(),
        abvPercent: (json['abvPercent'] as num).toDouble(),
        timestamp:
            DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
      );
}
