import 'dart:io';
import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../l10n/gen/app_localizations.dart';
import 'hydration_service.dart';
import 'reminder_scheduler.dart';
import 'settings_service.dart';

/// Resolves the device's language to localized notification text. Uses
/// [Platform.localeName] rather than a [BuildContext] since this runs both
/// from the main isolate (before the widget tree exists, at app startup)
/// and from the background notification-response isolate, neither of
/// which has a Flutter widget tree to look a locale up from.
Future<AppLocalizations> _loadNotificationLocalizations() {
  final languageCode = Platform.localeName.split(RegExp('[_-]')).first;
  final supported = AppLocalizations.supportedLocales
      .map((l) => l.languageCode)
      .contains(languageCode);
  return AppLocalizations.delegate.load(Locale(supported ? languageCode : 'en'));
}

const String reminderChannelId = 'hydration_reminders';
const String reminderChannelName = 'Hydration reminders';
const int reminderNotificationId = 1;

/// Action id for the "Drank it" button shown on the reminder notification.
const String drankActionId = 'drank_action';

/// Amount logged when a drink is confirmed from the notification itself,
/// since the tray has no room for a custom-amount picker.
const int _quickConfirmMl = 250;

bool _tzReady = false;

Future<void> _ensureTimezone() async {
  if (_tzReady) return;
  tzdata.initializeTimeZones();
  try {
    final local = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(local.identifier));
  } catch (_) {
    tz.setLocalLocation(tz.UTC);
  }
  _tzReady = true;
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _ensureTimezone();

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: handleNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: notificationBackgroundHandler,
    );

    await _createChannel();
  }

  Future<void> _createChannel() async {
    final loc = await _loadNotificationLocalizations();
    final channel = AndroidNotificationChannel(
      reminderChannelId,
      reminderChannelName,
      description: loc.notificationChannelDescription,
      importance: Importance.high,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Re-localizes the notification channel description and re-schedules
  /// the next reminder in the current locale. A reminder's text is baked
  /// in at schedule time rather than resolved when it fires, so without
  /// this an already-scheduled reminder stays in whatever language was
  /// active the last time it was (re)scheduled -- call this whenever the
  /// app's locale changes (e.g. from [WidgetsBindingObserver.didChangeLocales]).
  Future<void> refreshLocale() async {
    await _createChannel();
    await rescheduleFromNow();
  }

  Future<void> requestPermissions() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
    await android?.requestExactAlarmsPermission();
  }

  Future<void> cancelReminder() => _plugin.cancel(id: reminderNotificationId);

  /// Recomputes the next reminder from now using the saved settings,
  /// schedules it with the OS, and persists it so the UI can show it.
  Future<DateTime> rescheduleFromNow() async {
    final settings = await SettingsService.instance.load();
    final next = computeNextReminder(
      from: DateTime.now(),
      intervalMinutes: settings.intervalMinutes,
      activeStartMinutes: settings.activeStartMinutes,
      activeEndMinutes: settings.activeEndMinutes,
    );
    await _scheduleAt(next, settings.message);
    await HydrationService.instance.saveNextReminderAt(next);
    return next;
  }

  /// Reuses a still-future stored reminder time instead of resetting the
  /// countdown every time the app is opened; falls back to rescheduling
  /// when nothing is stored yet or the stored time has already passed.
  Future<DateTime> ensureScheduled() async {
    final stored = await HydrationService.instance.loadNextReminderAt();
    if (stored != null && stored.isAfter(DateTime.now())) {
      return stored;
    }
    return rescheduleFromNow();
  }

  Future<void> _scheduleAt(DateTime at, String? message) async {
    await _ensureTimezone();
    await cancelReminder();
    final loc = await _loadNotificationLocalizations();
    await _plugin.zonedSchedule(
      id: reminderNotificationId,
      title: loc.notificationTitle,
      body: message ?? loc.notificationDefaultMessage,
      scheduledDate: tz.TZDateTime.from(at, tz.local),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          reminderChannelId,
          reminderChannelName,
          channelDescription: loc.notificationChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
          actions: [
            AndroidNotificationAction(
              drankActionId,
              loc.notificationActionLabel,
              showsUserInterface: false,
            ),
          ],
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}

/// Confirms a drink and reschedules the next reminder. Shared by the
/// foreground callback and the background isolate entry point below so
/// tapping "Drank it" behaves identically either way.
Future<void> handleNotificationResponse(NotificationResponse response) async {
  if (response.actionId != drankActionId) return;
  await HydrationService.instance.logDrink(_quickConfirmMl);
  await NotificationService.instance.rescheduleFromNow();
}

@pragma('vm:entry-point')
void notificationBackgroundHandler(NotificationResponse response) {
  handleNotificationResponse(response);
}
