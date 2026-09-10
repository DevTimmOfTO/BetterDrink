import 'beverage_kind.dart';

/// A single logged non-alcoholic drink.
class WaterEntry {
  const WaterEntry({
    required this.id,
    required this.volumeMl,
    required this.timestamp,
    this.kind = BeverageKind.water,
  });

  final String id;

  /// The volume actually poured, independent of how much of it counts
  /// toward the daily goal — see [hydrationMl].
  final int volumeMl;

  final DateTime timestamp;
  final BeverageKind kind;

  /// Millilitres credited toward the daily goal, after the drink kind's
  /// hydration factor.
  int get hydrationMl => kind.hydrationMl(volumeMl);

  WaterEntry copyWith({int? volumeMl}) => WaterEntry(
        id: id,
        volumeMl: volumeMl ?? this.volumeMl,
        timestamp: timestamp,
        kind: kind,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'volumeMl': volumeMl,
        'timestamp': timestamp.millisecondsSinceEpoch,
        'kind': kind.storageKey,
      };

  factory WaterEntry.fromJson(Map<String, dynamic> json) => WaterEntry(
        id: json['id'] as String,
        volumeMl: (json['volumeMl'] as num).toInt(),
        timestamp:
            DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
        kind: BeverageKind.fromStorageKey(json['kind'] as String?),
      );
}
