# Contributing

## Setup

Requires the Flutter stable channel, Android SDK/platform tools, and a full JDK (17+, `javac` not
just a JRE — `flutter_local_notifications` needs core library desugaring, already configured in
`android/app/build.gradle.kts`).

```bash
git clone https://github.com/DevTimmOfTO/BetterDrink.git
cd BetterDrink
flutter pub get
flutter run
```

### Release signing (optional, only needed to build a signed release APK)

`flutter run`/`flutter build apk --debug` work out of the box. A `flutter build apk --release`
build falls back to the debug key unless `android/key.properties` exists — that file is
gitignored, so each machine that needs to produce a real release build needs its own copy of the
keystore and a local `android/key.properties` pointing at it:

```properties
storePassword=...
keyPassword=...   # same value as storePassword — PKCS12 keystores don't support separate ones
keyAlias=betterdrink
storeFile=/absolute/path/to/betterdrink-release.jks
```

To generate a new keystore from scratch (only do this once, ever, for the project — see the
warning below):

```bash
keytool -genkeypair -v -keystore betterdrink-release.jks -alias betterdrink \
  -keyalg RSA -keysize 2048 -validity 10000
```

**This keystore is the app's permanent signing identity.** Losing it means every future release
build has a different identity from what's already installed on users' devices (or already
published), which Android treats as a different app entirely — there's no recovery path once a
version is out in the wild. Keep at least one backup of the keystore file somewhere other than
the machine it's used on (encrypted, e.g. `gpg --symmetric`), and never commit it or
`key.properties` to git.

## Before opening a PR

```bash
flutter analyze     # must be clean
flutter test         # must pass
```

For any UI change, actually run the app on a device or emulator and exercise the change — the
test suite covers pure logic (see [TESTING.md](TESTING.md)), not whether a screen looks or feels
right.

## Commit messages

This repo does **not** use the default `Co-Authored-By: Claude ...` trailer for AI-assisted
commits. If a commit was made possible by Claude, use this trailer instead, with no session link:

```
Made possible and cleaned up by Claude
```

## Code conventions

These aren't enforced by lint, but the codebase is consistent about them — match the existing
style rather than introducing a new pattern:

- **New feature = the same three-layer shape.** A new feature area gets a model
  (`lib/models/`), a singleton service (`lib/services/`, `Service._()` + static `instance`,
  reading/writing `shared_preferences` directly), a `Notifier` provider (`lib/providers/`), and a
  screen/widgets. See [ARCHITECTURE.md](ARCHITECTURE.md) for the full shape and the
  cross-feature-effects convention (route feature-to-feature calls through
  `ref.read(otherProvider.notifier)` in a provider method, not service-to-service, unless the
  effect is genuinely part of the originating service's own responsibility — like streak
  recording being part of "logging a drink").
- **Pull business logic out as pure functions when it doesn't need persistence.** This is what
  makes `alcohol_calculator.dart`, `reminder_scheduler.dart`, `history_aggregator.dart`, etc.
  unit-testable without mocking `shared_preferences` — see [TESTING.md](TESTING.md).
- **Doc comments explain the non-obvious WHY, not the WHAT.** Skip a comment on
  `final String id;` or a mechanical `build()` override. Do write one when there's a gotcha, an
  invariant, or a design choice a reader would otherwise have to reconstruct — a bug this shape of
  code works around, why a value is clamped, why one isolate's state can't be trusted. Look at
  `lib/services/health_connect_service.dart` or `lib/services/notification_service.dart` for the
  target voice.
- **Don't add inline `//` comments explaining what code obviously does.** Same bar as doc
  comments: only the non-obvious why.
- **Persisted values need an old-install-safe default.** Every service reads with
  `prefs.getX(key) ?? SomeDefault` rather than assuming a key exists — see
  [DATA_PERSISTENCE.md](DATA_PERSISTENCE.md) before adding or renaming a storage key.

## Adding or changing a localized string

1. Add the key to `lib/l10n/app_en.arb` (the template) with a `@key` metadata block if it takes
   placeholders (see existing entries for the format).
2. Add the same key's translation to `lib/l10n/app_de.arb` and `lib/l10n/app_fr.arb`. Don't leave
   a locale behind — a missing key falls back to the template Falsely rather than failing loudly.
3. Run `flutter gen-l10n` (or just `flutter run`/`flutter test`, which trigger it automatically)
   to regenerate `lib/l10n/gen/app_localizations*.dart`. Never hand-edit those generated files.
4. Reference the string via `AppLocalizations.of(context)!.yourKey` in widgets, or via the
   `AppLocalizations` instance already threaded through `NotificationService` for
   notification/background-isolate text (see ARCHITECTURE.md's localization note for why that path
   can't use `BuildContext`).

## Scope notes

This app is Android-only by design — iOS/desktop scaffolding was intentionally removed (see git
history). Don't reintroduce other-platform plumbing without discussing it first; a change that
only makes sense for another platform is out of scope.

The BAC estimate and the sugar-limit nudge are both explicitly informational, not medical advice —
preserve that framing in any copy or UI changes touching them (see [FEATURES.md](FEATURES.md)).
