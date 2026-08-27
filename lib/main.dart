import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/gen/app_localizations.dart';
import 'navigation/root_shell.dart';
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
class BetterDrinkApp extends StatelessWidget {
  const BetterDrinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BetterDrink',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const RootShell(),
    );
  }
}
