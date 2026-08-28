import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/gen/app_localizations.dart';
import '../models/achievement.dart';
import '../providers/hydration_entries_provider.dart';
import '../providers/hydration_history_provider.dart';
import '../providers/hydration_provider.dart';
import '../providers/settings_provider.dart';
import '../services/date_key.dart';
import '../services/history_aggregator.dart';
import '../widgets/countdown_ring.dart';
import '../widgets/history_chart.dart';
import '../widgets/quick_add_row.dart';
import '../widgets/water_history_list.dart';

/// Number of trailing days shown in the Trends chart.
const int _trendWindowDays = 14;

/// Hydration tab: a depleting countdown ring to the next reminder, today's
/// total intake, and quick-add buttons for logging a drink.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final Timer _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final nextReminderAt = ref.watch(hydrationProvider);
    final settings = ref.watch(settingsProvider);
    final entries = ref.watch(hydrationEntriesProvider);
    final history = ref.watch(hydrationHistoryProvider);

    final remaining = nextReminderAt == null
        ? Duration.zero
        : nextReminderAt.difference(DateTime.now());
    final total = Duration(minutes: settings.intervalMinutes);
    final todayKey = dateKey(DateTime.now());
    final todayMl = entries
        .where((e) => dateKey(e.timestamp) == todayKey)
        .fold<int>(0, (sum, e) => sum + e.volumeMl);
    final trendPoints = fillMissingDays(history, days: _trendWindowDays);

    return Scaffold(
      appBar: AppBar(title: Text(loc.homeAppBarTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            Center(
              child: CountdownRing(
                remaining: remaining.isNegative ? Duration.zero : remaining,
                total: total,
                timeLabel: _formatRemaining(remaining, loc),
                subLabel: remaining.isNegative
                    ? loc.homeReminderDue
                    : loc.homeUntilNextReminder,
              ),
            ),
            const SizedBox(height: 24),
            _TodayTotalCard(todayMl: todayMl),
            const SizedBox(height: 20),
            QuickAddRow(
              onAdd: (ml) async {
                final unlocked =
                    await ref.read(hydrationProvider.notifier).logDrink(ml);
                if (unlocked.isNotEmpty && context.mounted) {
                  _showUnlockSnackBar(context, loc, unlocked);
                }
              },
            ),
            const SizedBox(height: 28),
            Text(loc.historyTitle, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            WaterHistoryList(
              entries: entries,
              onDelete: (id) =>
                  ref.read(hydrationEntriesProvider.notifier).removeEntry(id),
              onEdit: (id, ml) =>
                  ref.read(hydrationEntriesProvider.notifier).editEntry(id, ml),
            ),
            const SizedBox(height: 28),
            Text(loc.trends, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            HistoryChart(
              points: trendPoints,
              unit: loc.mlUnit,
              goalLine: settings.dailyGoalMl.toDouble(),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _TodayTotalCard extends StatelessWidget {
  const _TodayTotalCard({required this.todayMl});

  final int todayMl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.water_drop_rounded, color: colorScheme.primary),
            const SizedBox(width: 10),
            Text(
              AppLocalizations.of(context)!.homeTodayMl(todayMl),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

void _showUnlockSnackBar(
  BuildContext context,
  AppLocalizations loc,
  List<AchievementId> unlocked,
) {
  final titles = unlocked
      .map((id) => achievementCatalog(loc).firstWhere((a) => a.id == id).title)
      .join(', ');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(loc.homeAchievementUnlocked(titles))),
  );
}

String _formatRemaining(Duration remaining, AppLocalizations loc) {
  if (remaining.isNegative || remaining == Duration.zero) return loc.homeNow;
  final hours = remaining.inHours;
  final minutes = remaining.inMinutes.remainder(60);
  final seconds = remaining.inSeconds.remainder(60);
  if (hours > 0) {
    return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
  }
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}
