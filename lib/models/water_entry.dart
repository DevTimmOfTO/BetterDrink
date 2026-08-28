/// A single logged water intake.
class WaterEntry {
  const WaterEntry({
    required this.id,
    required this.volumeMl,
    required this.timestamp,
  });

  final String id;
  final int volumeMl;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
        'id': id,
        'volumeMl': volumeMl,
        'timestamp': timestamp.millisecondsSinceEpoch,
      };

  factory WaterEntry.fromJson(Map<String, dynamic> json) => WaterEntry(
        id: json['id'] as String,
        volumeMl: (json['volumeMl'] as num).toInt(),
        timestamp:
            DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
      );
}
