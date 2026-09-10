# BetterDrink

A Flutter app for Android that helps you stay hydrated and keep an eye on alcohol and sugar
consumption.

## Features

### Hydration reminders
- A depleting circular countdown ring shows time remaining until your next reminder to drink
  water.
- Reminders fire as local notifications on a configurable interval, even when the app is in the
  background or closed, and keep firing on their own even if one is missed or swiped away.
- An **active hours** window keeps reminders from firing while you're asleep.
- Log a drink with one tap (250 ml / 500 ml presets) or a custom amount, either from the app or
  directly from the notification.
- Log water, coffee, or tea — coffee and tea count at a reduced share of their poured volume
  toward your daily goal, since caffeine is mildly diuretic.
- Today's credited intake is shown on the Home tab.
- A **Trends** chart shows your daily intake (ml) over the last 14 days.
- Optionally mirror logged water entries to **Google Health Connect** as Hydration records
  (Settings) — a one-way, best-effort sync; nothing is ever read back from Health Connect.

### Sugar tracking
- One-tap logging for typical sugary drinks (soda, juice, energy drinks, ...) with realistic
  default volume/sugar content, or enter a custom drink.
- Today's total and a history of everything logged, newest first.
- A gentle nudge once today's logged drinks alone pass the WHO's recommended daily free-sugar
  guideline — informational only, not medical advice.
- A **Trends** chart shows grams of sugar consumed per day over the last 14 days.

### Alcohol tracking
- A rough, estimated blood-alcohol (BAC) countdown, built from the classic Widmark formula using
  your sex, age, and weight (set in Settings).
- One-tap logging for typical drinks (beer, wine, spirits, cocktails, ...) with realistic default
  volume/strength, or enter a custom drink.
- A history of everything logged, newest first, swipe to delete.
- A permanent reminder that **alcohol is a drug** and can be harmful, plus a help button linking
  to a few known support resources.
- A **Trends** chart shows grams of alcohol consumed per day over the last 14 days.

> The BAC estimate is for personal, informational use only. It is **not** medical advice and must
> never be used to judge fitness to drive.

### Leaderboard, streaks & achievements
- Tracks your current and best hydration streak (consecutive days you've logged at least one
  drink).
- Streak resets automatically if you miss a day.
- **Achievements** unlock for streak milestones, hitting your daily hydration goal repeatedly, and
  total drinks logged.
- **Compare with friends**, entirely locally: share your streak as a short text code through any
  app you like (chat, SMS, ...), and paste a friend's code to see their numbers next to yours. No
  accounts, no backend, no data leaves your device unless you share it yourself — it's a manual,
  point-in-time snapshot, not a live sync.

### Settings
- Reminder interval (minutes).
- Active hours window (start/end time).
- Custom notification message.
- Daily hydration goal (ml), used to track goal-hit achievements.
- Alcohol profile (sex, age, weight) used only to personalize the BAC estimate — it never leaves
  the device.
- Appearance: Material You dynamic color (Android 12+) and an optional system font family.
- Google Health Connect sync toggle for hydration entries.

## Tech stack

- [Flutter](https://flutter.dev) (stable channel) targeting Android only
- [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) (`Notifier`/`NotifierProvider` API) for state management
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) + [timezone](https://pub.dev/packages/timezone) for scheduled, timezone-aware background notifications
- [shared_preferences](https://pub.dev/packages/shared_preferences) for local persistence — no backend, no accounts, no data leaves the device
- [health](https://pub.dev/packages/health) for the optional Google Health Connect hydration sync
- [fl_chart](https://pub.dev/packages/fl_chart) for the Trends bar charts
- [dynamic_color](https://pub.dev/packages/dynamic_color) for Material You theming
- Material 3 theming with a custom seed color and rounded corners
- Localized (English, German, French) via `flutter_localizations` + ARB files

## Getting started

### Prerequisites
- Flutter SDK (stable channel)
- Android SDK / platform tools
- A JDK with a full compiler (`javac`), not just a JRE — JDK 17 or newer.
  `flutter_local_notifications` requires [core library desugaring](https://developer.android.com/studio/write/java8-support#library-desugaring),
  which is already configured in `android/app/build.gradle.kts`.

### Setup
```bash
git clone https://github.com/DevTimmOfTO/BetterDrink.git
cd BetterDrink
flutter pub get
flutter run
```

### Running tests
```bash
flutter test
```
Pure logic (the reminder scheduler, BAC and sugar calculators, achievement rules, trend
aggregation, and streak-code encoding) is unit-tested independently of Flutter/plugin bindings in
`test/`. See [docs/TESTING.md](docs/TESTING.md) for the full breakdown.

### Building an APK
```bash
flutter build apk --debug    # or --release
```

## Project structure

```
lib/
  data/         # static preset data (typical drinks, sugary drinks, serving sizes)
  l10n/         # ARB translation source + generated localization code
  models/       # plain data classes
  navigation/   # bottom-nav shell switching between tabs
  providers/    # Riverpod Notifier state
  screens/      # Home, Sugar, Alcohol, Leaderboard, Settings tabs
  services/     # persistence + business logic (pure where possible)
  theme/        # Material 3 theme
  widgets/      # reusable UI pieces
  main.dart
test/           # unit tests for pure logic, one widget test
docs/           # architecture, feature walkthroughs, and contributor docs — see docs/README.md
```

## Documentation

For anything beyond this overview — the layered architecture, a per-feature code walkthrough, the
full `shared_preferences` key inventory, testing conventions, and how to contribute — see
**[docs/README.md](docs/README.md)**.

## License

Licensed under the [GNU General Public License v3.0](LICENSE).
