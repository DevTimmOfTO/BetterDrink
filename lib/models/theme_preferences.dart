/// User-configurable appearance options, persisted via [ThemeService].
class ThemePreferences {
  const ThemePreferences({
    required this.useDynamicColor,
    required this.fontFamily,
  });

  static const ThemePreferences defaults = ThemePreferences(
    useDynamicColor: true,
    fontFamily: null,
  );

  /// Whether to theme the app from the device's wallpaper-derived accent
  /// color (Material You, Android 12+) instead of the app's own seed color.
  final bool useDynamicColor;

  /// An Android system font family name (e.g. 'serif'), or null to use the
  /// Material default (Roboto).
  final String? fontFamily;
}
