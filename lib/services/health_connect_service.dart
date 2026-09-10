import 'package:health/health.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/water_entry.dart';

/// Outcome of [HealthConnectService.setEnabled], used by the settings UI to
/// show a specific message when turning sync on doesn't succeed.
enum HealthConnectSyncResult {
  enabled,
  disabled,
  needsHealthConnectInstall,
  permissionDenied,
}

/// Wraps the `health` plugin to optionally mirror logged water entries into
/// Google Health Connect as Hydration records. Alcohol isn't synced -- Health
/// Connect has no alcohol data type at all (confirmed against both the
/// official Nutrition record field list and this plugin's data type enum),
/// unlike Apple HealthKit's `numberOfAlcoholicBeverages`.
class HealthConnectService {
  HealthConnectService._();
  static final HealthConnectService instance = HealthConnectService._();

  static const _keyEnabled = 'health_connect_sync_enabled';
  static const _waterTypes = [HealthDataType.WATER];

  final Health _health = Health();
  bool _configured = false;

  Future<void> _ensureConfigured() async {
    if (_configured) return;
    await _health.configure();
    _configured = true;
  }

  Future<bool> loadEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyEnabled) ?? false;
  }

  Future<void> _saveEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyEnabled, value);
  }

  /// Turning sync on checks Health Connect availability (prompting a Play
  /// Store install/update if it's missing or outdated) and requests WRITE
  /// access for Hydration, only persisting the opt-in once both succeed.
  /// Turning it off just persists false -- it deliberately doesn't call the
  /// plugin's `revokePermissions()`, since that revokes every Health Connect
  /// permission app-wide and requires a full app restart, far more invasive
  /// than switching off this one feature.
  Future<HealthConnectSyncResult> setEnabled(bool value) async {
    if (!value) {
      await _saveEnabled(false);
      return HealthConnectSyncResult.disabled;
    }

    await _ensureConfigured();
    try {
      final status = await _health.getHealthConnectSdkStatus();
      if (status != HealthConnectSdkStatus.sdkAvailable) {
        await _health.installHealthConnect();
        return HealthConnectSyncResult.needsHealthConnectInstall;
      }

      final granted = await _health.requestAuthorization(
        _waterTypes,
        permissions: const [HealthDataAccess.WRITE],
      );
      if (!granted) return HealthConnectSyncResult.permissionDenied;

      await _saveEnabled(true);
      return HealthConnectSyncResult.enabled;
    } catch (_) {
      return HealthConnectSyncResult.permissionDenied;
    }
  }

  /// Writes [entry] to Health Connect as a Hydration record if sync is
  /// enabled. Never throws -- Health Connect being uninstalled or a
  /// permission revoked outside the app must not break logging a drink, so
  /// any failure here is swallowed rather than propagated to the caller.
  Future<void> syncWaterEntry(WaterEntry entry) async {
    if (!await loadEnabled()) return;
    try {
      await _ensureConfigured();
      await _health.writeHealthData(
        value: entry.volumeMl / 1000,
        unit: HealthDataUnit.LITER,
        type: HealthDataType.WATER,
        startTime: entry.timestamp,
        // Health Connect's HydrationRecord requires startTime to be
        // strictly before endTime -- passing the same instant for both
        // makes the write throw, so nudge endTime forward by a second.
        endTime: entry.timestamp.add(const Duration(seconds: 1)),
      );
    } catch (_) {
      // Best-effort sync -- see the doc comment above.
    }
  }
}
