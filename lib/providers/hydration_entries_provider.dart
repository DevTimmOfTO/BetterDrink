import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/water_entry.dart';
import '../services/hydration_service.dart';

/// Holds the logged [WaterEntry] history, keeping it in sync with
/// on-device persistence.
class HydrationEntriesNotifier extends Notifier<List<WaterEntry>> {
  @override
  List<WaterEntry> build() {
    _load();
    return const [];
  }

  Future<void> _load() async {
    state = await HydrationService.instance.loadEntries();
  }

  Future<void> reload() => _load();

  Future<void> addEntry(int volumeMl) async {
    state = await HydrationService.instance.logDrink(volumeMl);
  }

  Future<void> removeEntry(String id) async {
    final updated = state.where((e) => e.id != id).toList();
    state = updated;
    await HydrationService.instance.saveEntries(updated);
  }

  Future<void> editEntry(String id, int volumeMl) async {
    final updated = [
      for (final e in state)
        if (e.id == id)
          WaterEntry(id: e.id, volumeMl: volumeMl, timestamp: e.timestamp)
        else
          e,
    ];
    state = updated;
    await HydrationService.instance.saveEntries(updated);
  }
}

final hydrationEntriesProvider =
    NotifierProvider<HydrationEntriesNotifier, List<WaterEntry>>(
  HydrationEntriesNotifier.new,
);
