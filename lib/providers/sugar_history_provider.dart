import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/history_aggregator.dart';
import 'sugar_provider.dart';

/// Derives per-day sugar totals (grams) directly from the in-memory drink
/// list — no separate persistence needed since [sugarProvider] already
/// holds the full retained history.
final sugarHistoryProvider = Provider<Map<String, double>>((ref) {
  final drinks = ref.watch(sugarProvider);
  return bucketSugarByDay(drinks);
});
