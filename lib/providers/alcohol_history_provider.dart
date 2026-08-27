import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/history_aggregator.dart';
import 'alcohol_provider.dart';

/// Derives per-day alcohol totals (grams of pure alcohol) directly from
/// the in-memory drink list — no separate persistence needed since
/// [alcoholProvider] already holds the full retained history.
final alcoholHistoryProvider = Provider<Map<String, double>>((ref) {
  final drinks = ref.watch(alcoholProvider);
  return bucketDrinksByDay(drinks);
});
