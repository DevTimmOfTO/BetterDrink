import 'package:health/health.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';
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
  static const _profileTypes = [
    HealthDataType.WEIGHT,
    HealthDataType.HEIGHT,
    HealthDataType.GENDER,
    HealthDataType.BIRTH_DATE,
  ];

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

  /// Request READ permissions for profile data (weight, height, gender, birth date)
  /// from Health Connect. Returns true if permissions were granted.
  Future<bool> requestProfileReadPermissions() async {
    await _ensureConfigured();
    try {
      final status = await _health.getHealthConnectSdkStatus();
      if (status != HealthConnectSdkStatus.sdkAvailable) {
        await _health.installHealthConnect();
        return false;
      }
      final granted = await _health.requestAuthorization(
        _profileTypes,
        permissions: const [HealthDataAccess.READ],
      );
      return granted;
    } catch (_) {
      return false;
    }
  }

  /// Reads the latest weight from Health Connect in kilograms.
  /// Returns null if not available or on error.
  Future<double?> readWeightKg() async {
    await _ensureConfigured();
    try {
      final now = DateTime.now();
      final oneYearAgo = now.subtract(const Duration(days: 365));
      final data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.WEIGHT],
        startTime: oneYearAgo,
        endTime: now,
        preferredUnits: {HealthDataType.WEIGHT: HealthDataUnit.KILOGRAM},
      );
      if (data.isEmpty) return null;
      
      // Get the most recent data point
      data.sort((a, b) => b.dateFrom.compareTo(a.dateFrom));
      final latest = data.first;
      
      // The value should be a NumericHealthValue
      if (latest.value is NumericHealthValue) {
        return (latest.value as NumericHealthValue).numericValue.toDouble();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Reads the latest height from Health Connect in meters.
  /// Returns null if not available or on error.
  Future<double?> readHeightM() async {
    await _ensureConfigured();
    try {
      final now = DateTime.now();
      final oneYearAgo = now.subtract(const Duration(days: 365));
      final data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.HEIGHT],
        startTime: oneYearAgo,
        endTime: now,
        preferredUnits: {HealthDataType.HEIGHT: HealthDataUnit.METER},
      );
      if (data.isEmpty) return null;
      
      // Get the most recent data point
      data.sort((a, b) => b.dateFrom.compareTo(a.dateFrom));
      final latest = data.first;
      
      // The value should be a NumericHealthValue
      if (latest.value is NumericHealthValue) {
        return (latest.value as NumericHealthValue).numericValue.toDouble();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Reads gender from Health Connect.
  /// Returns null if not available or on error.
  Future<Sex?> readGender() async {
    await _ensureConfigured();
    try {
      final now = DateTime.now();
      final oneYearAgo = now.subtract(const Duration(days: 365));
      final data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.GENDER],
        startTime: oneYearAgo,
        endTime: now,
      );
      if (data.isEmpty) return null;
      
      final latest = data.first;
      // Gender is typically returned as a numeric value (0, 1, 2, etc.)
      // We need to map it to our Sex enum
      // Based on Android Health Connect: FEMALE = 1, MALE = 2, OTHER = 0 or 3
      if (latest.value is NumericHealthValue) {
        final genderValue = (latest.value as NumericHealthValue).numericValue;
        // Map Health Connect gender values to our Sex enum
        // Health Connect uses: UNKNOWN = 0, FEMALE = 1, MALE = 2, OTHER = 3
        if (genderValue == 1) return Sex.female;
        if (genderValue == 2) return Sex.male;
        if (genderValue == 3) return Sex.other;
        // 0 or any other value -> use other as default
        return Sex.other;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Reads birth date from Health Connect.
  /// Returns null if not available or on error.
  Future<DateTime?> readBirthDate() async {
    await _ensureConfigured();
    try {
      final now = DateTime.now();
      final oneYearAgo = now.subtract(const Duration(days: 365));
      final data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.BIRTH_DATE],
        startTime: oneYearAgo,
        endTime: now,
      );
      if (data.isEmpty) return null;
      
      final latest = data.first;
      // Birth date might be returned as a DateTime in the value
      // or we can use the dateFrom field
      if (latest.value is NumericHealthValue) {
        // The numeric value might be a timestamp in milliseconds
        final timestamp = (latest.value as NumericHealthValue).numericValue;
        return DateTime.fromMillisecondsSinceEpoch(timestamp.toInt());
      }
      // Try using dateFrom as fallback
      return latest.dateFrom;
    } catch (_) {
      return null;
    }
  }

  /// Reads age from Health Connect based on birth date.
  /// Returns null if birth date not available or on error.
  Future<int?> readAge() async {
    final birthDate = await readBirthDate();
    if (birthDate == null) return null;
    
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    // Adjust if birthday hasn't occurred yet this year
    if (now.month < birthDate.month || 
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age > 0 ? age : null;
  }

  /// Reads all profile data (sex, age, weight) from Health Connect.
  /// Returns a UserProfile with the available data, or null if no data is available.
  /// If some data is unavailable, uses the defaults from UserProfile.defaults.
  Future<UserProfile?> readProfile() async {
    final sex = await readGender();
    final age = await readAge();
    final weightKg = await readWeightKg();
    
    // If we couldn't read any data, return null
    if (sex == null && age == null && weightKg == null) {
      return null;
    }
    
    // Use available data, fall back to defaults for missing values
    return UserProfile(
      sex: sex ?? UserProfile.defaults.sex,
      age: age ?? UserProfile.defaults.age,
      weightKg: weightKg ?? UserProfile.defaults.weightKg,
    );
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
  /// enabled. Syncs the poured volume, not this app's credited hydration --
  /// a Hydration record documents liquid actually consumed, and other apps
  /// reading it shouldn't inherit our coffee/tea factors.
  ///
  /// Never throws -- Health Connect being uninstalled or a permission
  /// revoked outside the app must not break logging a drink, so any failure
  /// here is swallowed rather than propagated to the caller.
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
