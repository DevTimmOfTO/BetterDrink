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

  /// Turns Health Connect sync on or off. Turning it on checks Health
  /// Connect availability and requests write permission, only updating
  /// state (and persisting the opt-in) if both succeed; turning it off
  /// always succeeds. Returns the outcome so the settings UI can show a
  /// specific message (e.g. prompting a Health Connect install) when
  /// enabling doesn't succeed.
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
