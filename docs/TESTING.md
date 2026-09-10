# Testing

```bash
flutter test                                       # everything
flutter test test/alcohol_calculator_test.dart      # one file
```

## What's covered

`test/` has one test file per pure-logic module, plus one widget test:

| Test file | Covers |
|---|---|
| `alcohol_calculator_test.dart` | Widmark BAC math (`lib/services/alcohol_calculator.dart`) |
| `sugar_calculator_test.dart` | Grams-of-sugar math (`lib/services/sugar_calculator.dart`) |
| `reminder_scheduler_test.dart` | Reminder time-window math (`lib/services/reminder_scheduler.dart`) |
| `achievement_rules_test.dart` | Achievement unlock thresholds (`lib/services/achievement_rules.dart`) |
| `history_aggregator_test.dart` | Day-bucketing and gap-filling for trend charts (`lib/services/history_aggregator.dart`) |
| `date_key_test.dart` | `YYYY-MM-DD` key formatting (`lib/services/date_key.dart`) |
| `streak_code_test.dart` | Streak-share code encode/decode round-trip (`lib/services/streak_code.dart`) |
| `leaderboard_service_test.dart` | Streak advance/reset/gap logic |
| `widget_test.dart` | Smoke test that the app boots and renders |

All of the above except `leaderboard_service_test.dart` and `widget_test.dart` test **free
functions with no Flutter or plugin bindings** — no `WidgetTester`, no mocked
`SharedPreferences`, no `flutter_local_notifications` stub. That's a deliberate architectural
choice (see [ARCHITECTURE.md](ARCHITECTURE.md)): logic that doesn't strictly need persistence or
Flutter is pulled out into standalone functions specifically so it can be tested this directly.
`leaderboard_service_test.dart` is the one exception that touches a service — it works because
`shared_preferences`' in-memory test backend (`SharedPreferences.setMockInitialValues`) is enough
to exercise `LeaderboardService` without a real device.

## Adding a test for new pure logic

If you're adding business logic that doesn't need `shared_preferences` or a `BuildContext`, write
it as a free function (or a handful of them) in `lib/services/`, the way `alcohol_calculator.dart`
and `reminder_scheduler.dart` do, and give it a matching `test/xxx_test.dart`. Rule of thumb:
if a function's signature is just plain Dart types in, plain Dart types out, it belongs in a
testable free function rather than buried inside a service method or a provider.

For a new pure-logic file, mirror an existing test's structure — e.g. `date_key_test.dart` for the
simplest possible example, or `history_aggregator_test.dart` for one that covers several related
functions and edge cases (empty input, exact boundary values, missing days).

## What isn't covered, and why

Screens, widgets, providers, and most of `services/` (the `shared_preferences`-touching CRUD
methods, `NotificationService`, `HealthConnectService`) have no automated tests. These are thin
wrappers around Flutter/plugin APIs and device state that are impractical to unit test
meaningfully without a real device or heavy mocking, and the project has chosen to keep the pure
logic underneath them well-tested instead. If you add non-trivial *logic* to one of these layers
(not just plumbing), consider whether it can be extracted into a pure function first.

Before opening a PR, also see [CONTRIBUTING.md](CONTRIBUTING.md)'s checklist — `flutter analyze`
and `flutter test` both need to pass, and for UI changes the app should actually be run and
exercised on a device/emulator (test suites verify logic, not that a screen looks or feels right).
