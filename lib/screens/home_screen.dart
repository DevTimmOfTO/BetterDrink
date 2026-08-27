import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/achievement.dart';
import '../providers/hydration_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/countdown_ring.dart';
import '../widgets/quick_add_row.dart';

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
    final hydration = ref.watch(hydrationProvider);
    final settings = ref.watch(settingsProvider);

    final nextReminderAt = hydration.nextReminderAt;
    final remaining = nextReminderAt == null
        ? Duration.zero
        : nextReminderAt.difference(DateTime.now());
    final total = Duration(minutes: settings.intervalMinutes);

    return Scaffold(
      appBar: AppBar(title: const Text('BetterDrink')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: CountdownRing(
                    remaining: remaining.isNegative ? Duration.zero : remaining,
                    total: total,
                    timeLabel: _formatRemaining(remaining),
                    subLabel: remaining.isNegative
                        ? 'reminder due'
                        : 'until next reminder',
                  ),
                ),
              ),
              _TodayTotalCard(todayMl: hydration.todayMl),
              const SizedBox(height: 20),
              QuickAddRow(
                onAdd: (ml) async {
                  final unlocked =
                      await ref.read(hydrationProvider.notifier).logDrink(ml);
                  if (unlocked.isNotEmpty && context.mounted) {
                    _showUnlockSnackBar(context, unlocked);
                  }
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
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
              '$todayMl ml today',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

void _showUnlockSnackBar(BuildContext context, List<AchievementId> unlocked) {
  final titles = unlocked
      .map((id) => achievementCatalog.firstWhere((a) => a.id == id).title)
      .join(', ');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Achievement unlocked: $titles')),
  );
}

String _formatRemaining(Duration remaining) {
  if (remaining.isNegative || remaining == Duration.zero) return 'Now';
  final hours = remaining.inHours;
  final minutes = remaining.inMinutes.remainder(60);
  final seconds = remaining.inSeconds.remainder(60);
  if (hours > 0) {
    return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
  }
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}
