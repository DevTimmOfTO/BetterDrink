# Architecture

BetterDrink is a Flutter app, Android-only, with no backend and no accounts — everything lives
on-device via `shared_preferences`. This doc expands on the summary in [CLAUDE.md](../CLAUDE.md)
with the reasoning behind the shape of the code, for anyone about to add or change a feature.

## The three-layer stack

Every feature (hydration, sugar, alcohol, leaderboard, settings) follows the same shape:

```
screens/   (UI, ConsumerWidget)
   |  ref.watch(...) / ref.read(...notifier)
   v
providers/ (Riverpod Notifier — in-memory state + orchestration)
   |  calls into
   v
services/  (singleton — shared_preferences persistence + business logic)
```

- **`lib/services/`** — one singleton class per feature area (`FooService._()` constructor +
  static `instance` getter). Services read and write `shared_preferences` directly and hold no
  Flutter dependencies where possible. Pure logic that doesn't need persistence — the Widmark BAC
  math (`alcohol_calculator.dart`), reminder time-window math (`reminder_scheduler.dart`), day
  bucketing (`history_aggregator.dart`, `date_key.dart`), achievement thresholds
  (`achievement_rules.dart`), streak-code encoding (`streak_code.dart`) — is pulled out as free
  functions specifically so it's unit-testable without mocking storage. See
  [TESTING.md](TESTING.md).

- **`lib/providers/`** — Riverpod `Notifier`s. Riverpod 3's `Notifier` doesn't support an async
  `build()`, so the pattern everywhere is: `build()` kicks off an async `_load()` and returns a
  synchronous placeholder immediately (usually `null` or an empty/default value), and real state
  lands a tick later once persistence resolves. Screens that watch these providers need to handle
  that placeholder frame (a loading spinner, or just rendering "0" until data arrives).

- **`lib/screens/`** — one file per bottom-nav tab, `ConsumerWidget`/`ConsumerStatefulWidget`
  consuming providers via `ref.watch`/`ref.read`.

- **`lib/widgets/`** — reusable UI pieces shared across or within screens (charts, history lists,
  preset grids, the countdown ring).

- **`lib/models/`** — plain data classes, mostly with `toJson`/`fromJson` for the JSON blobs
  services store as `shared_preferences` string values.

- **`lib/data/`** — static preset data (typical drinks, typical sugary drinks, default serving
  sizes) — content, not logic.

### Cross-feature effects

When one feature needs to affect another, that call goes through `ref.read(otherProvider.notifier)`
inside a notifier method — **not** by having one service call another feature's service directly.
For example, `HydrationNotifier.logDrink` (`lib/providers/hydration_provider.dart`):

1. Calls `HydrationEntriesNotifier.addEntry`, which persists the entry via `HydrationService`.
   `HydrationService.logDrink` itself calls `LeaderboardService.recordDrink()` and
   `HealthConnectService.syncWaterEntry()` — that's service-to-service, allowed because streak
   bookkeeping and the optional Health Connect mirror are considered part of "logging a drink."
2. Explicitly reschedules the reminder notification.
3. Calls `ref.read(leaderboardProvider.notifier).reload()` so the Leaderboard tab picks up the
   new streak without needing its own polling.
4. Reads achievement-relevant stats and calls `achievementProvider.notifier.checkForNewUnlocks(...)`,
   returning any newly-unlocked achievements so the UI can show unlock feedback.

The rule of thumb: a service may reach into another *service* for something that's really part of
its own responsibility (streaks are a side effect of logging a drink, full stop). A provider reaches
into another *provider* when the point is to refresh UI-facing state that lives elsewhere.

### `LeaderboardService` is the odd one out

Every other service is stateless — it reads fresh from `shared_preferences` on every call, so
there's no load-before-use ordering requirement. `LeaderboardService` instead caches
`currentStreak` / `bestStreak` / `lastDate` in mutable instance fields, loaded once via `load()`
and mutated in place before being persisted via `_save()`. `LeaderboardNotifier.reload()` re-runs
`load()` to pick up changes made elsewhere (e.g. after `HydrationService.logDrink` calls
`recordDrink()` on the same singleton instance).

This matters most for `recordDrink()`: it can run inside a **fresh background isolate** — the
notification's "Drank it" action fires `notificationBackgroundHandler`, which runs even when the
app process isn't alive — where the in-memory fields default to zero/empty because `load()` was
never called in that isolate. `recordDrink()` reloads from disk itself before mutating, specifically
to avoid silently overwriting an existing on-disk streak with garbage computed from those defaults.

## Notifications and reminder scheduling

`NotificationService` (singleton, `lib/services/notification_service.dart`) wraps
`flutter_local_notifications` + `timezone`.

- `main()` calls `NotificationService.instance.init()` and `.requestPermissions()` **before**
  `runApp` — a reminder can fire while the app isn't running, so the plugin needs to be wired up
  before there's a widget tree.
- `ensureScheduled()` reuses a still-future stored reminder time (persisted via
  `HydrationService.saveNextReminderAt`) rather than resetting the countdown every time the app
  opens. `rescheduleFromNow()` recomputes a *batch* of `reminderBatchSize` (24) upcoming reminders
  from the current settings and schedules all of them with the OS at once — scheduling ahead like
  this, rather than just the next occurrence, is what keeps the series firing on its own if one
  notification is missed or swiped away without the app being reopened (see GitHub issue #8).
- `computeNextReminder` / `computeReminderBatch` (`reminder_scheduler.dart`) are pure: they add the
  interval and clamp the result into the user's active-hours window
  (`[activeStartMinutes, activeEndMinutes)`). They assume `activeStartMinutes < activeEndMinutes` —
  a same-day window (e.g. 8:00–22:00), not one that wraps past midnight.
- The "Drank it" notification action and the background isolate entry point
  (`notificationBackgroundHandler`, annotated `@pragma('vm:entry-point')` so it survives tree
  shaking as a standalone entry point) both funnel through `handleNotificationResponse` so
  foreground and background taps behave identically: log 250ml, then reschedule.
- `refreshLocale()` re-creates the notification channel description and reschedules when the
  device/app locale changes (`BetterDrinkApp.didChangeLocales`) — a reminder's text is baked in at
  schedule time, not resolved when it fires, so without this an already-scheduled reminder would
  stay in whatever language was active the last time it was (re)scheduled.

## Health Connect integration

`HealthConnectService` (`lib/services/health_connect_service.dart`) optionally mirrors logged
water entries into Google Health Connect as Hydration records, wrapping the `health` plugin.
Alcohol is **not** synced — Health Connect has no alcohol data type. Sync is best-effort: turning
it on requires both a Health Connect availability check and a granted WRITE permission before the
opt-in is persisted; turning it off just persists `false` without calling the plugin's
`revokePermissions()` (that revokes every Health Connect permission app-wide and needs a full app
restart — far more than switching off this one feature). `syncWaterEntry` never throws; a failure
there must not break logging a drink in the app itself.

## Navigation and theming

`RootShell` (`lib/navigation/root_shell.dart`) uses an `IndexedStack` — not a route-based
navigator — across five tabs (Home/hydration, Sugar, Alcohol, Leaderboard, Settings), so each tab
keeps its state (countdown timers, scroll position) when switching away and back.

Theming (`lib/theme/app_theme.dart`, driven by `themeProvider`) supports Material You dynamic
color (derived from the device wallpaper on Android 12+, via the `dynamic_color` package) and an
optional system font family override, both persisted via `ThemeService` and toggled from Settings.

## Localization

UI strings are defined in `lib/l10n/*.arb` (English is the template, `app_en.arb`; German and
French translations live alongside it) and compiled by the `flutter gen-l10n` tool (see
`l10n.yaml`) into `lib/l10n/gen/app_localizations*.dart` — those generated files are checked in but
should never be hand-edited. See [CONTRIBUTING.md](CONTRIBUTING.md) for the workflow to add a new
string.
