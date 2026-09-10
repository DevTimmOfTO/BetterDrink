import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/health_connect_service.dart';

/// Whether Health Connect water sync is enabled. Actual syncing happens in
/// [HealthConnectService.syncWaterEntry], called from [HydrationService.logDrink]
/// -- this provider only backs the settings toggle's on/off state.
class HealthConnectNotifier extends Notifier<bool> {
  @override
  bool build() {
    _load();
    return false;
  }

  Future<void> _load() async {
    state = await HealthConnectService.instance.loadEnabled();
  }

  Future<HealthConnectSyncResult> setEnabled(bool value) async {
    final result = await HealthConnectService.instance.setEnabled(value);
    if (result == HealthConnectSyncResult.enabled ||
        result == HealthConnectSyncResult.disabled) {
      state = value;
    }
    return result;
  }
}

final healthConnectProvider =
    NotifierProvider<HealthConnectNotifier, bool>(HealthConnectNotifier.new);
