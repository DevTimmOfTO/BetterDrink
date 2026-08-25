# BetterDrink

A Flutter app for Android that helps you stay hydrated and keep an eye on
alcohol consumption.

## Features

### Hydration reminders
- A depleting circular countdown ring shows time remaining until your next
  reminder to drink water.
- Reminders fire as local notifications on a configurable interval, even
  when the app is in the background or closed.
- An **active hours** window keeps reminders from firing while you're
  asleep.
- Log a drink with one tap (250 ml / 500 ml presets) or a custom amount,
  either from the app or directly from the notification.
- Today's total intake is shown on the Home tab.

### Alcohol tracking
- A rough, estimated blood-alcohol (BAC) countdown, built from the classic
  Widmark formula using your sex, age, and weight (set in Settings).
- One-tap logging for typical drinks (beer, wine, spirits, cocktails, ...)
  with realistic default volume/strength, or enter a custom drink.
- A history of everything logged, newest first, swipe to delete.
- A permanent reminder that **alcohol is a drug** and can be harmful, plus
  a help button linking to a few known support resources.

> The BAC estimate is for personal, informational use only. It is **not**
> medical advice and must never be used to judge fitness to drive.

### Leaderboard & streaks
- Tracks your current and best hydration streak (consecutive days you've
  logged at least one drink).
- Streak resets automatically if you miss a day.

### Settings
- Reminder interval (minutes).
- Active hours window (start/end time).
- Custom notification message.
- Alcohol profile (sex, age, weight) used only to personalize the BAC
  estimate — it never leaves the device.

## Tech stack

- [Flutter](https://flutter.dev) (stable channel) targeting Android only
- [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) (`Notifier`/`NotifierProvider` API) for state management
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) + [timezone](https://pub.dev/packages/timezone) for scheduled, timezone-aware background notifications
- [shared_preferences](https://pub.dev/packages/shared_preferences) for local persistence — no backend, no accounts, no data leaves the device
- Material 3 theming with a custom seed color and rounded corners

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
Pure logic (the reminder scheduler and the BAC calculator) is unit-tested
independently of Flutter/plugin bindings in `test/`.

### Building an APK
```bash
flutter build apk --debug    # or --release
```

## Project structure

```
lib/
  data/         # static preset data (typical drinks)
  models/       # plain data classes
  navigation/   # bottom-nav shell switching between tabs
  providers/    # Riverpod Notifier state
  screens/      # Home, Alcohol, Leaderboard, Settings tabs
  services/     # persistence + business logic (pure where possible)
  theme/        # Material 3 theme
  widgets/      # reusable UI pieces
  main.dart
test/           # unit tests for pure logic, one widget test
```

## Roadmap

- Drink history charts and trends
- Gamification / achievements for hydration goals
- Social leaderboard (compare streaks with friends)

## License

Licensed under the [GNU General Public License v3.0](LICENSE).
