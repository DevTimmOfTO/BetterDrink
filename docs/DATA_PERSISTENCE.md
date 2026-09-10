# Data persistence

BetterDrink has no backend — every piece of state lives in `shared_preferences` on-device,
written and read by the singleton `services/` classes described in
[ARCHITECTURE.md](ARCHITECTURE.md). This is the full key inventory, grouped by owning service, so
you can tell at a glance what a given service actually persists and what would need a migration if
its shape changed.

Entry lists are stored as `List<String>` where each string is one JSON-encoded model
(`jsonEncode(entry.toJson())`); this keeps each entry decodable independently, at the cost of
re-encoding the whole list on every write.

## `HydrationService` — `lib/services/hydration_service.dart`

| Key | Type | Holds |
|---|---|---|
| `hydration_entries` | `List<String>` (JSON `WaterEntry`) | Logged water/coffee/tea entries, retained 30 days |
| `hydration_last_reset_date` | `String` (`YYYY-MM-DD`) | Last date the goal-hit check ran, so it only fires once per day |
| `hydration_next_reminder_at` | `int` (epoch ms) | Next scheduled reminder, drives the countdown ring |
| `settings_goal_hit_days` | `int` | Lifetime count of days the daily goal was hit — feeds achievements |
| `hydration_total_drinks_logged` | `int` | Lifetime count of drinks logged — feeds achievements |
| `hydration_today_ml` *(legacy)* | `int` | Pre-#1 single cumulative total; migrated into a synthetic entry on first load after upgrade, then removed |
| `hydration_history` *(legacy)* | `String` (JSON map, day → ml) | Pre-#1 day-bucketed history with no per-entry detail; migrated the same way |

`WaterEntry.kind` is stored via `BeverageKind.storageKey` (`'water'`/`'coffee'`/`'tea'`), a value
kept deliberately separate from the enum's `name` so renaming an enum member can't silently orphan
stored entries — see `BeverageKind.fromStorageKey`, which falls back to `water` for entries logged
before drink kinds existed at all (no key present).

## `AlcoholService` — `lib/services/alcohol_service.dart`

| Key | Type | Holds |
|---|---|---|
| `alcohol_drinks` | `List<String>` (JSON `DrinkEntry`) | Logged alcoholic drinks, retained 30 days |
| `alcohol_profile_sex` | `int` (`Sex` enum index) | BAC-estimate profile |
| `alcohol_profile_age` | `int` | BAC-estimate profile |
| `alcohol_profile_weight_kg` | `double` | BAC-estimate profile |

## `SugarService` — `lib/services/sugar_service.dart`

| Key | Type | Holds |
|---|---|---|
| `sugar_drinks` | `List<String>` (JSON `SugarEntry`) | Logged sugary drinks, retained 30 days |

## `LeaderboardService` — `lib/services/leaderboard_service.dart`

| Key | Type | Holds |
|---|---|---|
| `streak_current` | `int` | Current consecutive-day streak |
| `streak_best` | `int` | Best streak ever recorded |
| `streak_last_date` | `String` (`YYYY-MM-DD`) | Last date a drink was logged, used to detect same-day/consecutive-day/gap |

Unlike every other service, `LeaderboardService` caches these in mutable instance fields rather
than reading `shared_preferences` fresh on every call — see ARCHITECTURE.md for why that matters
for the notification background isolate.

## `AchievementService` — `lib/services/achievement_service.dart`

| Key | Type | Holds |
|---|---|---|
| `achievements_unlocked` | `List<String>` (`AchievementId.name`) | Which achievements have been unlocked |

Renaming an `AchievementId` enum value changes its storage key — old installs with that value
already unlocked would silently lose it. Add new achievements as new enum values; don't rename
existing ones.

## `SettingsService` — `lib/services/settings_service.dart`

| Key | Type | Holds |
|---|---|---|
| `settings_interval_minutes` | `int` | Reminder interval |
| `settings_active_start_minutes` | `int` | Active-hours window start (minutes since midnight) |
| `settings_active_end_minutes` | `int` | Active-hours window end (minutes since midnight) |
| `settings_message` | `String?` | Custom reminder notification body; absent means use the localized default |
| `settings_daily_goal_ml` | `int` | Daily hydration goal |

## `ThemeService` — `lib/services/theme_service.dart`

| Key | Type | Holds |
|---|---|---|
| `theme_use_dynamic_color` | `bool` | Whether to use Material You dynamic color |
| `theme_font_family` | `String?` | Android system font family override; absent means Roboto |

## `HealthConnectService` — `lib/services/health_connect_service.dart`

| Key | Type | Holds |
|---|---|---|
| `health_connect_sync_enabled` | `bool` | Whether logged water entries mirror to Google Health Connect |

Only the opt-in flag is stored here — Health Connect itself is the source of truth for the synced
records once written; this app never reads them back.

## `FriendsService` — `lib/services/friends_service.dart`

| Key | Type | Holds |
|---|---|---|
| `friends_snapshots` | `List<String>` (JSON `FriendSnapshot`) | Imported friend streak snapshots (point-in-time, pasted in manually) |
| `friends_own_display_name` | `String` | Name shown to friends who import a code exported from this device |

Snapshots and streak-share codes never touch a network — see `lib/services/streak_code.dart` for
the base64/JSON encoding used to pack a streak into a copy-pasteable string.

## Adding a new persisted field

1. Add the field to the relevant model, with `toJson`/`fromJson` support.
2. Add a `_keyXxx` constant and load/save logic in the owning service. Give old installs a sane
   default via `?? SomeDefault` on read, the way every existing service does — there's no schema
   migration mechanism beyond the ad hoc one `HydrationService` uses for its pre-#1 legacy keys.
3. If the field affects an already-encoded JSON blob (an entry inside a list), decoding old JSON
   that lacks the new field must not throw — either make it nullable or give `fromJson` a fallback.
