/// A single logged sugary drink.
class SugarEntry {
  const SugarEntry({
    required this.id,
    required this.name,
    required this.volumeMl,
    required this.sugarPer100ml,
    required this.timestamp,
  });

  final String id;
  final String name;
  final double volumeMl;

  /// Grams of sugar per 100ml, the sugar-drink analogue of ABV%.
  final double sugarPer100ml;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'volumeMl': volumeMl,
        'sugarPer100ml': sugarPer100ml,
        'timestamp': timestamp.millisecondsSinceEpoch,
      };

  factory SugarEntry.fromJson(Map<String, dynamic> json) => SugarEntry(
        id: json['id'] as String,
        name: json['name'] as String,
        volumeMl: (json['volumeMl'] as num).toDouble(),
        sugarPer100ml: (json['sugarPer100ml'] as num).toDouble(),
        timestamp:
            DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
      );
}
