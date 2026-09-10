import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/beverage_kind.dart';
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

  Future<void> addEntry(int volumeMl, {required BeverageKind kind}) async {
    state = await HydrationService.instance.logDrink(volumeMl, kind: kind);
  }

  Future<void> removeEntry(String id) async {
    final updated = state.where((e) => e.id != id).toList();
    state = updated;
    await HydrationService.instance.saveEntries(updated);
  }

  /// Corrects an entry's amount, keeping its drink kind — the edit dialog
  /// only offers the volume.
  Future<void> editEntry(String id, int volumeMl) async {
    final updated = [
      for (final e in state)
        if (e.id == id) e.copyWith(volumeMl: volumeMl) else e,
    ];
    state = updated;
    await HydrationService.instance.saveEntries(updated);
  }
}

final hydrationEntriesProvider =
    NotifierProvider<HydrationEntriesNotifier, List<WaterEntry>>(
  HydrationEntriesNotifier.new,
);
