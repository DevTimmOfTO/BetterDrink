import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/gen/app_localizations.dart';
import 'navigation/root_shell.dart';
import 'providers/theme_provider.dart';
import 'services/notification_service.dart';
import 'theme/app_theme.dart';

/// Entry point: sets up notifications before the widget tree exists, since
/// a scheduled reminder can fire before the user ever opens the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();
  await NotificationService.instance.requestPermissions();
  runApp(const ProviderScope(child: BetterDrinkApp()));
}

/// Root widget: wires up the Material 3 theme and the tabbed [RootShell].
class BetterDrinkApp extends ConsumerStatefulWidget {
  const BetterDrinkApp({super.key});

  @override
  ConsumerState<BetterDrinkApp> createState() => _BetterDrinkAppState();
}

class _BetterDrinkAppState extends ConsumerState<BetterDrinkApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Re-localizes the reminder notification (channel description + the
  /// next scheduled reminder's text) when the device or per-app language
  /// changes, since its text would otherwise stay stuck in whatever
  /// language was active when it was last scheduled.
  @override
  void didChangeLocales(List<Locale>? locales) {
    NotificationService.instance.refreshLocale();
  }

  @override
  Widget build(BuildContext context) {
    final themePrefs = ref.watch(themeProvider);
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        final useDynamic = themePrefs.useDynamicColor;
        return MaterialApp(
          title: 'BetterDrink',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(
            dynamicScheme: useDynamic ? lightDynamic : null,
            fontFamily: themePrefs.fontFamily,
          ),
          darkTheme: AppTheme.dark(
            dynamicScheme: useDynamic ? darkDynamic : null,
            fontFamily: themePrefs.fontFamily,
          ),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const RootShell(),
        );
      },
    );
  }
}
