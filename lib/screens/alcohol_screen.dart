import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/alcohol_history_provider.dart';
import '../providers/alcohol_provider.dart';
import '../providers/profile_provider.dart';
import '../services/alcohol_calculator.dart';
import '../services/history_aggregator.dart';
import '../theme/app_theme.dart';
import '../widgets/alcohol_help_sheet.dart';
import '../widgets/countdown_ring.dart';
import '../widgets/drink_history_list.dart';
import '../widgets/drink_preset_grid.dart';
import '../widgets/history_chart.dart';

/// Number of trailing days shown in the Trends chart.
const int _trendWindowDays = 14;

/// Alcohol-consumption tab: an estimated blood-alcohol overview, one-tap
/// logging for typical drinks, and a history of what's been logged.
class AlcoholScreen extends ConsumerStatefulWidget {
  const AlcoholScreen({super.key});

  @override
  ConsumerState<AlcoholScreen> createState() => _AlcoholScreenState();
}

class _AlcoholScreenState extends ConsumerState<AlcoholScreen> {
  late final Timer _ticker;

  @override
  void initState() {
    super.initState();
    // The BAC estimate depends on elapsed time, so refresh periodically
    // even without new drinks being logged.
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) {
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
    final drinks = ref.watch(alcoholProvider);
    final profile = ref.watch(profileProvider);
    final alcoholHistory = ref.watch(alcoholHistoryProvider);
    final trendPoints = fillMissingDays(alcoholHistory, days: _trendWindowDays);
    final now = DateTime.now();
    final currentBac = estimateBac(drinks: drinks, at: now, profile: profile);
    final peakBac = drinks.isEmpty
        ? 0.0
        : estimateBac(drinks: drinks, at: drinks.first.timestamp, profile: profile);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alcohol'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            tooltip: 'Get help',
            onPressed: () => showAlcoholHelpSheet(context),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const _AlcoholWarningBanner(),
            const SizedBox(height: 20),
            _BacOverview(currentBac: currentBac, peakBac: peakBac),
            const SizedBox(height: 28),
            Text('Log a drink', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            DrinkPresetGrid(
              onAdd: (name, volumeMl, abvPercent) => ref
                  .read(alcoholProvider.notifier)
                  .addDrink(name: name, volumeMl: volumeMl, abvPercent: abvPercent),
            ),
            const SizedBox(height: 28),
            Text('History', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            DrinkHistoryList(
              drinks: drinks,
              onDelete: (id) => ref.read(alcoholProvider.notifier).removeDrink(id),
            ),
            const SizedBox(height: 28),
            Text('Trends', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            HistoryChart(points: trendPoints, unit: 'g'),
          ],
        ),
      ),
    );
  }
}

class _AlcoholWarningBanner extends StatelessWidget {
  const _AlcoholWarningBanner();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(appCornerRadius),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: colorScheme.onErrorContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Alcohol is a drug. It can be addictive and harmful to your '
              'health. Tap the help icon above if you\'d like support.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onErrorContainer,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BacOverview extends StatelessWidget {
  const _BacOverview({required this.currentBac, required this.peakBac});

  final double currentBac;
  final double peakBac;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (currentBac <= 0) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            children: [
              Icon(Icons.check_circle_rounded, color: colorScheme.primary, size: 40),
              const SizedBox(height: 12),
              Text('0.0‰ · sober', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                'Log a drink below to start tracking.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      );
    }

    final remaining = timeToZeroBac(currentBac);
    final total = timeToZeroBac(peakBac < currentBac ? currentBac : peakBac);

    return Center(
      child: Column(
        children: [
          CountdownRing(
            remaining: remaining,
            total: total,
            timeLabel: _formatDuration(remaining),
            subLabel: '${currentBac.toStringAsFixed(2)}‰ · until 0.0‰',
          ),
          const SizedBox(height: 12),
          Text(
            'Estimate only — not medical advice. Never drive on alcohol.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

String _formatDuration(Duration d) {
  final hours = d.inHours;
  final minutes = d.inMinutes.remainder(60);
  if (hours > 0) return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
  return '${minutes}m';
}
