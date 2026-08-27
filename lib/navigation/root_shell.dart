import 'package:betterdrink/screens/leaderboard_screen.dart';
import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';
import '../screens/alcohol_screen.dart';
import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/sugar_screen.dart';

/// Bottom-navigation shell switching between the Home, Alcohol, and
/// Settings tabs. Uses an [IndexedStack] so each tab keeps its state
/// (e.g. countdown timers) when switching away and back.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    SugarScreen(),
    AlcoholScreen(),
    LeaderboardScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.water_drop_outlined),
            selectedIcon: const Icon(Icons.water_drop_rounded),
            label: loc.navAlcoholFree,
          ),
          NavigationDestination(
            icon: const Icon(Icons.local_drink_outlined),
            selectedIcon: const Icon(Icons.local_drink_rounded),
            label: loc.navSugar,
          ),
          NavigationDestination(
            icon: const Icon(Icons.local_bar_outlined),
            selectedIcon: const Icon(Icons.local_bar_rounded),
            label: loc.navAlcohol,
          ),
          NavigationDestination(
            icon: const Icon(Icons.leaderboard_outlined),
            selectedIcon: const Icon(Icons.leaderboard_rounded),
            label: loc.navLeaderboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings_rounded),
            label: loc.navSettings,
          ),
        ],
      ),
    );
  }
}
