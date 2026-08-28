import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/history_aggregator.dart';
import 'hydration_entries_provider.dart';

/// Derives per-day hydration totals (ml) directly from the in-memory water
/// entry list — no separate persistence needed since
/// [hydrationEntriesProvider] already holds the full retained history.
final hydrationHistoryProvider = Provider<Map<String, int>>((ref) {
  final entries = ref.watch(hydrationEntriesProvider);
  return bucketWaterByDay(entries);
});
