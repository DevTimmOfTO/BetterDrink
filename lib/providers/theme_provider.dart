import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/theme_preferences.dart';
import '../services/theme_service.dart';

/// Holds the current [ThemePreferences], keeping persistence in sync.
class ThemeNotifier extends Notifier<ThemePreferences> {
  @override
  ThemePreferences build() {
    _load();
    return ThemePreferences.defaults;
  }

  Future<void> _load() async {
    state = await ThemeService.instance.load();
  }

  Future<void> update(ThemePreferences preferences) async {
    state = preferences;
    await ThemeService.instance.save(preferences);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemePreferences>(
  ThemeNotifier.new,
);
