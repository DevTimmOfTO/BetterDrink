import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/hydration_service.dart';

/// Holds the day-bucketed hydration history (date key -> total ml),
/// keeping it in sync with on-device persistence.
class HydrationHistoryNotifier extends Notifier<Map<String, int>> {
  @override
  Map<String, int> build() {
    _load();
    return const {};
  }

  Future<void> _load() async {
    state = await HydrationService.instance.loadHistory();
  }

  Future<void> reload() => _load();
}

final hydrationHistoryProvider =
    NotifierProvider<HydrationHistoryNotifier, Map<String, int>>(
  HydrationHistoryNotifier.new,
);
