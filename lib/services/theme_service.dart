import 'package:shared_preferences/shared_preferences.dart';

import '../models/theme_preferences.dart';

/// Persists [ThemePreferences] to on-device storage via shared_preferences.
class ThemeService {
  ThemeService._();
  static final ThemeService instance = ThemeService._();

  static const _keyUseDynamicColor = 'theme_use_dynamic_color';
  static const _keyFontFamily = 'theme_font_family';

  Future<ThemePreferences> load() async {
    final prefs = await SharedPreferences.getInstance();
    return ThemePreferences(
      useDynamicColor: prefs.getBool(_keyUseDynamicColor) ??
          ThemePreferences.defaults.useDynamicColor,
      fontFamily: prefs.getString(_keyFontFamily),
    );
  }

  Future<void> save(ThemePreferences preferences) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyUseDynamicColor, preferences.useDynamicColor);
    final fontFamily = preferences.fontFamily;
    if (fontFamily == null) {
      await prefs.remove(_keyFontFamily);
    } else {
      await prefs.setString(_keyFontFamily, fontFamily);
    }
  }
}
