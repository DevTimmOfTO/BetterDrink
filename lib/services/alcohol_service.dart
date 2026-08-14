import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/drink_entry.dart';
import '../models/user_profile.dart';

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
}
