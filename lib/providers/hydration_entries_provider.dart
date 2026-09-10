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

  /// Re-runs [_load] to pick up entries changed elsewhere (e.g. persisted
  /// directly through [HydrationService] outside this notifier).
  Future<void> reload() => _load();

  /// Logs [volumeMl] of [kind] via [HydrationService.logDrink], which also
  /// records the drink toward the streak (`LeaderboardService.recordDrink`)
  /// and, if enabled, syncs it to Health Connect -- neither of which is
  /// reflected here, since this notifier only updates its own entry-list
  /// state from the returned entries. Callers that need the leaderboard UI
  /// to reflect the new streak (e.g. [HydrationNotifier.logDrink]) must
  /// separately reload `leaderboardProvider`.
  Future<void> addEntry(int volumeMl, {required BeverageKind kind}) async {
    state = await HydrationService.instance.logDrink(volumeMl, kind: kind);
  }

  /// Removes the entry with [id] from state and persists the updated list.
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
