import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/drink_entry.dart';
import '../models/user_profile.dart';
import 'health_connect_service.dart';

/// Persists logged drinks and the user's BAC-calculation profile.
class AlcoholService {
  AlcoholService._();
  static final AlcoholService instance = AlcoholService._();

  static const _keyDrinks = 'alcohol_drinks';
  static const _keySex = 'alcohol_profile_sex';
  static const _keyAge = 'alcohol_profile_age';
  static const _keyWeight = 'alcohol_profile_weight_kg';

  /// Entries older than this no longer affect the BAC estimate, so they're
  /// dropped on load instead of growing the history forever.
  static const _historyRetention = Duration(days: 30);

  /// Loads drinks, dropping anything past [_historyRetention] and
  /// returning newest first.
  Future<List<DrinkEntry>> loadDrinks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_keyDrinks) ?? const [];
    final cutoff = DateTime.now().subtract(_historyRetention);
    final drinks = raw
        .map((e) => DrinkEntry.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .where((d) => d.timestamp.isAfter(cutoff))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return drinks;
  }

  Future<void> saveDrinks(List<DrinkEntry> drinks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _keyDrinks,
      drinks.map((d) => jsonEncode(d.toJson())).toList(),
    );
  }

  Future<UserProfile> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final sexIndex = prefs.getInt(_keySex);
    return UserProfile(
      sex: sexIndex == null ? UserProfile.defaults.sex : Sex.values[sexIndex],
      age: prefs.getInt(_keyAge) ?? UserProfile.defaults.age,
      weightKg: prefs.getDouble(_keyWeight) ?? UserProfile.defaults.weightKg,
    );
  }

  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keySex, profile.sex.index);
    await prefs.setInt(_keyAge, profile.age);
    await prefs.setDouble(_keyWeight, profile.weightKg);
  }

  /// Requests Health Connect READ permissions and reads each profile field
  /// individually, so the caller can offer a per-field import picker instead
  /// of applying everything at once. Returns null if permissions were denied
  /// or none of the fields have data in Health Connect.
  Future<HealthConnectProfileFields?> requestProfileFieldsFromHealthConnect() async {
    final permissionsGranted = await HealthConnectService.instance.requestProfileReadPermissions();
    if (!permissionsGranted) return null;

    final service = HealthConnectService.instance;
    final fields = HealthConnectProfileFields(
      sex: await service.readGender(),
      age: await service.readAge(),
      weightKg: await service.readWeightKg(),
    );
    return fields.isEmpty ? null : fields;
  }
}
