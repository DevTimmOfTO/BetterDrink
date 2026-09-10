# Features, end to end

Each section traces one feature from screen down to storage: the file you'd open first, and the
files it pulls in. Read [ARCHITECTURE.md](ARCHITECTURE.md) first for the general shape.

## Hydration (Home tab)

**Entry point:** `lib/screens/home_screen.dart`

- A depleting `CountdownRing` (`lib/widgets/countdown_ring.dart`) counts down to the next reminder,
  backed by `hydrationProvider` → `NotificationService.ensureScheduled()`.
- Logging a drink (`BeverageQuickAdd` widget, presets from `lib/data/beverage_servings.dart`) goes
  through `HydrationNotifier.logDrink` (`lib/providers/hydration_provider.dart`), which:
  1. Persists the entry via `hydrationEntriesProvider` → `HydrationService.logDrink`, which itself
     records a streak hit (`LeaderboardService.recordDrink`) and, if enabled, mirrors the entry to
     Google Health Connect (`HealthConnectService.syncWaterEntry`).
  2. Reschedules the reminder countdown.
  3. Reloads `leaderboardProvider` so the streak shown elsewhere stays in sync.
  4. Checks for newly-unlocked achievements and returns them for the UI to surface.
- **Coffee and tea count below their poured volume** — `BeverageKind.hydrationFactor`
  (`lib/models/beverage_kind.dart`) credits coffee at 80% and tea at 90% of volume toward the daily
  goal, since caffeine is mildly diuretic. This is a pragmatic tracking convention, not a clinical
  measure — keep that framing if you touch the copy around it.
- The **Trends** chart (`HistoryChart` widget) shows the last 14 days of *credited* ml, computed by
  `bucketWaterByDay` + `fillMissingDays` in `lib/services/history_aggregator.dart`.
- The reminder itself is a `flutter_local_notifications` schedule maintained by
  `NotificationService` — see ARCHITECTURE.md's "Notifications and reminder scheduling" section for
  the batching/background-isolate details, which are the trickiest part of this feature.

## Sugar tracking (Sugar tab)

**Entry point:** `lib/screens/sugar_screen.dart`

Structurally a near-twin of hydration tracking, but simpler — no reminders, no Health Connect sync,
no streak/achievement hooks. `SugarProvider` → `SugarService` persists `SugarEntry` records
(`volumeMl` + `sugarPer100ml`, the sugar-drink analogue of ABV%). `gramsOfSugar` in
`lib/services/sugar_calculator.dart` does the grams-per-serving math, and
`recommendedDailySugarLimitG` (WHO guideline, ~50g/day) is used to show an informational banner
once today's logged drinks alone cross it — not medical advice, just a nudge. Presets come from
`lib/data/typical_sugar_drinks.dart`. The Trends chart reuses `bucketSugarByDay` +
`fillMissingDays` from the same `history_aggregator.dart` used by hydration and alcohol.

## Alcohol / BAC tracking (Alcohol tab)

**Entry point:** `lib/screens/alcohol_screen.dart`

- One-tap logging for typical drinks (`lib/data/typical_drinks.dart`) or a custom entry, persisted
  as `DrinkEntry` via `AlcoholProvider` → `AlcoholService` (30-day retention, same pattern as
  hydration/sugar).
- The BAC estimate (`_BacOverview` widget) is computed by `estimateBac` in
  `lib/services/alcohol_calculator.dart`, using the classic **Widmark formula**: each drink's
  contribution decays independently from its own timestamp at a constant elimination rate
  (`eliminationRatePerHour`, a population average) and is floored at zero before being summed. The
  distribution factor (`widmarkFactor`) depends on the user's `Sex`, set in the alcohol profile
  (Settings) — it does not read from any body-fat or metabolism data, so the result is a rough
  estimate only.
- The countdown ring's `total` span is deliberately the *session's peak BAC*, not the current
  value — so logging a new drink mid-session extends the ring rather than snapping it back to
  full, which would misleadingly suggest a fresh countdown from zero.
- **This is explicitly informational, not medical advice, and must never be used to judge fitness
  to drive.** That framing is baked into the UI copy (a permanent warning banner) and a help sheet
  (`alcohol_help_sheet.dart`) linking to support resources — preserve it in any changes here.
- Trends chart: `bucketDrinksByDay` (grams of alcohol per day) from `history_aggregator.dart`.

## Leaderboard, streaks, achievements & friends

**Entry point:** `lib/screens/leaderboard_screen.dart`

- **Streaks** are maintained by `LeaderboardService` (see ARCHITECTURE.md for why it's the one
  stateful/caching service in the app) and surfaced via `leaderboardProvider`. A streak advances
  when `HydrationService.logDrink` calls `recordDrink()` — logging *any* drink kind on the Home tab
  counts, not a separate "streak" action.
- **Achievements** (`lib/models/achievement.dart` for the catalog, `AchievementRules.evaluateAchievements`
  in `lib/services/achievement_rules.dart` for the pure threshold logic, `AchievementService` for
  persistence) unlock for streak milestones (3/7/30 days), hitting the daily hydration goal
  repeatedly (5/30 days), and total drinks logged (50). New unlocks are checked right after logging
  a drink (see the Hydration section above) and shown via the `achievement_grid.dart` widget.
- **Friends** comparison is entirely local and manual: `encodeStreakCode`/`decodeStreakCode`
  (`lib/services/streak_code.dart`) pack a streak snapshot into a base64 text blob the user shares
  through any app they like (chat, SMS, ...); pasting a friend's code decodes it into a
  `FriendSnapshot` persisted by `FriendsService`. No accounts, no backend, nothing automatic — it's
  a point-in-time export/import, not a live sync. `decodeStreakCode` never throws on malformed
  input (returns `null`) so a mistyped/garbled code fails softly in the UI instead of crashing.

## Settings

**Entry point:** `lib/screens/settings_screen.dart`

- **Reminders**: interval, active-hours window, custom message, daily goal — `ReminderSettings`
  model, `SettingsService` persistence, consumed by `NotificationService` (see ARCHITECTURE.md).
- **Alcohol profile**: sex/age/weight, used only to personalize the BAC estimate — `UserProfile`
  model via `AlcoholService`.
- **Appearance**: Material You dynamic color toggle and an optional system font family override —
  `ThemePreferences` model, `ThemeService` persistence, read by `BetterDrinkApp` in `lib/main.dart`.
- **Health Connect**: the sync toggle (`_HealthConnectSection` widget) drives
  `healthConnectProvider` → `HealthConnectService.setEnabled`, which only turns sync on if both a
  Health Connect availability check and a WRITE-permission grant succeed — see ARCHITECTURE.md for
  why turning it *off* doesn't call the plugin's `revokePermissions()`.

## Localization

Strings live in `lib/l10n/*.arb` (`app_en.arb` is the template; `app_de.arb`/`app_fr.arb` are
translations) and are compiled into `lib/l10n/gen/app_localizations*.dart`. See
[CONTRIBUTING.md](CONTRIBUTING.md) for the exact workflow to add or change a string.
