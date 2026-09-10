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
import '../widgets/beverage_quick_add.dart';
import '../widgets/countdown_ring.dart';
import '../widgets/history_chart.dart';
import '../widgets/water_history_list.dart';

/// Number of trailing days shown in the Trends chart.
const int _trendWindowDays = 14;

/// Hydration tab: a depleting countdown ring to the next reminder, today's
/// credited intake, and per-drink quick-add buttons (coffee, tea, water).
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
    final todayEntries =
        entries.where((e) => dateKey(e.timestamp) == todayKey);
    final todayMl =
        todayEntries.fold<int>(0, (sum, e) => sum + e.hydrationMl);
    final todayPouredMl =
        todayEntries.fold<int>(0, (sum, e) => sum + e.volumeMl);
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
            _TodayTotalCard(todayMl: todayMl, pouredMl: todayPouredMl),
            const SizedBox(height: 20),
            BeverageQuickAdd(
              onAdd: (ml, kind) async {
                final unlocked = await ref
                    .read(hydrationProvider.notifier)
                    .logDrink(ml, kind: kind);
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

/// Today's intake. [todayMl] is what counts toward the goal; [pouredMl] is
/// what was actually drunk. They differ once coffee or tea is logged, and
/// the raw amount is spelled out underneath so the credited figure doesn't
/// look like lost entries.
class _TodayTotalCard extends StatelessWidget {
  const _TodayTotalCard({required this.todayMl, required this.pouredMl});

  final int todayMl;
  final int pouredMl;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.water_drop_rounded, color: colorScheme.primary),
                const SizedBox(width: 10),
                Text(
                  loc.homeTodayMl(todayMl),
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            if (pouredMl != todayMl) ...[
              const SizedBox(height: 4),
              Text(
                loc.homeTodayPouredNote(pouredMl),
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ],
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
