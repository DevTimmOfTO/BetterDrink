import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/reminder_settings.dart';
import '../services/notification_service.dart';
import '../services/settings_service.dart';

/// Holds the current [ReminderSettings], keeping persistence and the
/// notification schedule in sync whenever they change.
class SettingsNotifier extends Notifier<ReminderSettings> {
  @override
  ReminderSettings build() {
    _load();
    return ReminderSettings.defaults;
  }

  Future<void> _load() async {
    state = await SettingsService.instance.load();
  }

  /// Persists [settings] and immediately reschedules the next reminder
  /// so interval/active-hours/message changes take effect right away.
  Future<void> update(ReminderSettings settings) async {
    state = settings;
    await SettingsService.instance.save(settings);
    await NotificationService.instance.rescheduleFromNow();
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, ReminderSettings>(
  SettingsNotifier.new,
);
