import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/gen/app_localizations.dart';
import '../providers/sugar_history_provider.dart';
import '../providers/sugar_provider.dart';
import '../services/history_aggregator.dart';
import '../services/sugar_calculator.dart';
import '../services/date_key.dart';
import '../widgets/history_chart.dart';
import '../widgets/sugar_history_list.dart';
import '../widgets/sugar_preset_grid.dart';

/// Number of trailing days shown in the Trends chart.
const int _trendWindowDays = 14;

/// Sugar-consumption tab: today's total, one-tap logging for typical sugary
/// drinks, and a history of what's been logged.
class SugarScreen extends ConsumerWidget {
  const SugarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final drinks = ref.watch(sugarProvider);
    final sugarHistory = ref.watch(sugarHistoryProvider);
    final trendPoints = fillMissingDays(sugarHistory, days: _trendWindowDays);

    final todayKey = dateKey(DateTime.now());
    final todayGrams = drinks
        .where((d) => dateKey(d.timestamp) == todayKey)
        .fold<double>(
          0,
          (sum, d) => sum +
              gramsOfSugar(volumeMl: d.volumeMl, sugarPer100ml: d.sugarPer100ml),
        );

    return Scaffold(
      appBar: AppBar(title: Text(loc.sugarTabTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _TodayTotalCard(todayGrams: todayGrams),
            const SizedBox(height: 28),
            Text(loc.logASugarDrink, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SugarPresetGrid(
              onAdd: (name, volumeMl, sugarPer100ml) => ref
                  .read(sugarProvider.notifier)
                  .addDrink(name: name, volumeMl: volumeMl, sugarPer100ml: sugarPer100ml),
            ),
            const SizedBox(height: 28),
            Text(loc.historyTitle, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SugarHistoryList(
              drinks: drinks,
              onDelete: (id) => ref.read(sugarProvider.notifier).removeDrink(id),
            ),
            const SizedBox(height: 28),
            Text(loc.trends, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            HistoryChart(points: trendPoints, unit: 'g'),
          ],
        ),
      ),
    );
  }
}

class _TodayTotalCard extends StatelessWidget {
  const _TodayTotalCard({required this.todayGrams});

  final double todayGrams;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_drink_rounded, color: colorScheme.primary),
            const SizedBox(width: 10),
            Text(
              AppLocalizations.of(context)!
                  .sugarTodayGrams(todayGrams.toStringAsFixed(0)),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
