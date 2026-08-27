import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/sugar_entry.dart';

class SugarService {
  SugarService._();
  static final SugarService instance = SugarService._();

  static const _keyDrinks = 'sugar_drinks';

  /// Entries older than this no longer affect the trend chart, so they're
  /// dropped on load instead of growing the history forever.
  static const _historyRetention = Duration(days: 30);

  Future<List<SugarEntry>> loadDrinks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_keyDrinks) ?? const [];
    final cutoff = DateTime.now().subtract(_historyRetention);
    final drinks = raw
        .map((e) => SugarEntry.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .where((d) => d.timestamp.isAfter(cutoff))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return drinks;
  }

  Future<void> saveDrinks(List<SugarEntry> drinks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _keyDrinks,
      drinks.map((d) => jsonEncode(d.toJson())).toList(),
    );
  }
}
