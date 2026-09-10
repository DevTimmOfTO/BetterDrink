import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/sugar_entry.dart';
import '../services/sugar_service.dart';

/// Holds the logged [SugarEntry] history, keeping it in sync with
/// on-device persistence.
class SugarNotifier extends Notifier<List<SugarEntry>> {
  @override
  List<SugarEntry> build() {
    _load();
    return const [];
  }

  Future<void> _load() async {
    state = await SugarService.instance.loadDrinks();
  }

  /// Logs a new drink (defaulting its timestamp to now when [at] is
  /// omitted), prepends it to the in-memory list re-sorted newest-first,
  /// and persists the updated list.
  Future<void> addDrink({
    required String name,
    required double volumeMl,
    required double sugarPer100ml,
    DateTime? at,
  }) async {
    final entry = SugarEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      volumeMl: volumeMl,
      sugarPer100ml: sugarPer100ml,
      timestamp: at ?? DateTime.now(),
    );
    final updated = [entry, ...state]
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    state = updated;
    await SugarService.instance.saveDrinks(updated);
  }

  /// Removes the drink with [id] from state and persists the updated list.
  Future<void> removeDrink(String id) async {
    final updated = state.where((d) => d.id != id).toList();
    state = updated;
    await SugarService.instance.saveDrinks(updated);
  }
}

final sugarProvider = NotifierProvider<SugarNotifier, List<SugarEntry>>(
  SugarNotifier.new,
);
