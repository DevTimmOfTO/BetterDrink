import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/drink_entry.dart';
import '../services/alcohol_service.dart';

/// Holds the logged [DrinkEntry] history, keeping it in sync with
/// on-device persistence.
class AlcoholNotifier extends Notifier<List<DrinkEntry>> {
  @override
  List<DrinkEntry> build() {
    _load();
    return const [];
  }

  Future<void> _load() async {
    state = await AlcoholService.instance.loadDrinks();
  }

  Future<void> addDrink({
    required String name,
    required double volumeMl,
    required double abvPercent,
    DateTime? at,
  }) async {
    final entry = DrinkEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      volumeMl: volumeMl,
      abvPercent: abvPercent,
      timestamp: at ?? DateTime.now(),
    );
    final updated = [entry, ...state]
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    state = updated;
    await AlcoholService.instance.saveDrinks(updated);
  }

  Future<void> removeDrink(String id) async {
    final updated = state.where((d) => d.id != id).toList();
    state = updated;
    await AlcoholService.instance.saveDrinks(updated);
  }
}

final alcoholProvider = NotifierProvider<AlcoholNotifier, List<DrinkEntry>>(
  AlcoholNotifier.new,
);
