# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

BetterDrink is a Flutter app, Android-only (iOS/desktop scaffolding was removed — see git history), that helps
users stay hydrated and track alcohol and sugar consumption. No backend, no accounts — everything is persisted
on-device via `shared_preferences`, with an optional one-way mirror of hydration entries into Google Health
Connect.

See [docs/](docs/README.md) for deeper reference material (architecture, feature walkthroughs, the full
`shared_preferences` key inventory, and contributor conventions) than fits in this file.

## Commands

```bash
flutter pub get              # install dependencies
flutter run                  # run on a connected device/emulator
flutter test                 # run all tests
flutter test test/alcohol_calculator_test.dart   # run a single test file
flutter analyze              # static analysis (uses flutter_lints via analysis_options.yaml)
flutter build apk --debug    # or --release
```

Requires the Flutter stable channel and a full JDK (17+, not just a JRE) — `flutter_local_notifications`
needs core library desugaring, already configured in `android/app/build.gradle.kts`.

## Git commit trailer

When creating commits in this repo, do not use the default `Co-Authored-By: Claude ...` trailer. Use
`Made possible and cleaned up by Claude` instead, and do not include a session link.

Tests live in `test/`, one file per pure-logic module (`alcohol_calculator_test.dart`, `sugar_calculator_test.dart`,
`reminder_scheduler_test.dart`, `achievement_rules_test.dart`, `history_aggregator_test.dart`, `date_key_test.dart`,
`streak_code_test.dart`) plus `leaderboard_service_test.dart` and the one widget-level test, `widget_test.dart`.
See [docs/TESTING.md](docs/TESTING.md) for what's covered and how to add more.

## Architecture

Each feature (hydration, sugar, alcohol, leaderboard, settings) follows the same three-layer stack. See
[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the long version and [docs/FEATURES.md](docs/FEATURES.md) for
a per-feature, file-by-file walkthrough.

```
screens/ (UI) → providers/ (Riverpod Notifier) → services/ (singleton, persistence + business logic)
```

- **Services** (`lib/services/`) are singletons (`Service._()` + static `instance`) that read/write
  `shared_preferences` directly and hold no Flutter dependencies where possible. Business logic that doesn't
  need persistence (e.g. `alcohol_calculator.dart`'s Widmark BAC math, `reminder_scheduler.dart`'s time-window
  math) is written as free functions so it can be unit-tested without mocking storage.
- **Providers** (`lib/providers/`) are Riverpod `Notifier`s. `build()` kicks off an async `_load()` from the
  matching service and returns a synchronous placeholder state immediately (Riverpod 3 `Notifier` doesn't
  support an async `build()`), so state arrives a tick later once persistence resolves.
- **Screens** (`lib/screens/`) consume providers via `ConsumerWidget`/`ref.watch`.
- Cross-feature effects go through `ref.read(otherProvider.notifier)` calls inside a notifier method, not
  through the service layer — e.g. `HydrationNotifier.logDrink` calls `leaderboardProvider.notifier.reload()`
  after `HydrationService.logDrink` internally records a streak via `LeaderboardService.recordDrink()`.
- `LeaderboardService` differs from the others: it caches streak state in mutable instance fields (loaded via
  `load()`, mutated in-place, then persisted via `_save()`) rather than recomputing from `shared_preferences`
  on every read. `LeaderboardNotifier.reload()` re-runs `load()` to pick up changes made elsewhere.

### Notifications and reminder scheduling

`NotificationService` (singleton) wraps `flutter_local_notifications` + `timezone`. Key flow:
- `main()` calls `NotificationService.instance.init()` before `runApp`, since a reminder can fire while the
  app isn't running.
- `ensureScheduled()` reuses a still-future stored reminder time rather than resetting the countdown every
  time the app opens; `rescheduleFromNow()` recomputes from the current settings and reschedules with the OS.
  Both persist the next-reminder time via `HydrationService`, which is what drives the countdown ring UI.
- `computeNextReminder` (`reminder_scheduler.dart`) is pure: it adds the interval and clamps the result into
  the user's active-hours window. It assumes `activeStartMinutes < activeEndMinutes` (a same-day window, not
  one that wraps past midnight).
- The "Drank it" notification action and the background isolate entry point
  (`notificationBackgroundHandler`, annotated `@pragma('vm:entry-point')`) both funnel through
  `handleNotificationResponse` so foreground and background taps behave identically.

### Domain notes

- BAC estimation (`alcohol_calculator.dart`) uses the classic Widmark formula: each drink's contribution
  decays independently from its own timestamp and is floored at zero, then summed. It's explicitly
  informational-only, not medical advice — preserve that framing in any UI/copy changes.
- `RootShell` uses `IndexedStack` (not a route-based nav) so each tab (Home, Sugar, Alcohol, Leaderboard,
  Settings) keeps its state — e.g. countdown timers — when switching away and back.
