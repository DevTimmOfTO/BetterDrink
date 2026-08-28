import 'package:flutter/material.dart';

/// Water-themed seed color driving the whole Material 3 palette when the
/// device's dynamic (Material You) color scheme isn't used.
const Color _seed = Color(0xFF2BB6C4);

const double appCornerRadius = 28;

/// Builds the app's Material 3 [ThemeData] for light and dark mode, with
/// rounded corners applied throughout.
class AppTheme {
  AppTheme._();

  static ThemeData light({ColorScheme? dynamicScheme, String? fontFamily}) =>
      _build(Brightness.light, dynamicScheme: dynamicScheme, fontFamily: fontFamily);

  static ThemeData dark({ColorScheme? dynamicScheme, String? fontFamily}) =>
      _build(Brightness.dark, dynamicScheme: dynamicScheme, fontFamily: fontFamily);

  static ThemeData _build(
    Brightness brightness, {
    ColorScheme? dynamicScheme,
    String? fontFamily,
  }) {
    final colorScheme = dynamicScheme ??
        ColorScheme.fromSeed(seedColor: _seed, brightness: brightness);

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(appCornerRadius),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: colorScheme.surface,
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerHigh,
        shape: shape,
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHigh,
        // The base border is invisible (width 0) since fields are
        // distinguished by their fill color, not an outline — but that
        // width would carry over to the error state too unless given an
        // explicit, visible border here.
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        elevation: 0,
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
    );
  }
}
