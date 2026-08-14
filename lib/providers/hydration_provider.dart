import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/hydration_state.dart';
import '../services/hydration_service.dart';
import '../services/notification_service.dart';

/// Holds today's hydration total and the next reminder time, keeping
/// persistence and the notification schedule in sync with the UI.
class HydrationNotifier extends Notifier<HydrationState> {
  @override
  HydrationState build() {
    _load();
    return HydrationState.initial;
  }

  Future<void> _load() async {
    final todayMl = await HydrationService.instance.loadTodayMl();
    final next = await NotificationService.instance.ensureScheduled();
    state = HydrationState(todayMl: todayMl, nextReminderAt: next);
  }

  /// Logs a drink and restarts the countdown to the next reminder.
  Future<void> logDrink(int ml) async {
    final updated = await HydrationService.instance.logDrink(ml);
    final next = await NotificationService.instance.rescheduleFromNow();
    state = state.copyWith(todayMl: updated, nextReminderAt: next);
  }
}

final hydrationProvider = NotifierProvider<HydrationNotifier, HydrationState>(
  HydrationNotifier.new,
);
