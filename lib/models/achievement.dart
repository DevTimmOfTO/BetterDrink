import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';

/// Identifiers for every achievement in the catalog. The persisted "unlocked"
/// set stores [AchievementId.name] strings, so renaming a value here changes
/// its storage key — remove or rename with care.
enum AchievementId {
  streak3,
  streak7,
  streak30,
  goalHit5,
  goalHit30,
  drinksLogged50,
}

/// Static display metadata for one achievement. Unlock state is tracked
/// separately (see [AchievementService]) — this is just the catalog entry.
class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });

  final AchievementId id;
  final String title;
  final String description;
  final IconData icon;
}

/// Builds the achievement catalog with display text localized via [loc].
List<Achievement> achievementCatalog(AppLocalizations loc) => [
      Achievement(
        id: AchievementId.streak3,
        title: loc.achievementStreak3Title,
        description: loc.achievementStreak3Desc,
        icon: Icons.local_fire_department_rounded,
      ),
      Achievement(
        id: AchievementId.streak7,
        title: loc.achievementStreak7Title,
        description: loc.achievementStreak7Desc,
        icon: Icons.local_fire_department_rounded,
      ),
      Achievement(
        id: AchievementId.streak30,
        title: loc.achievementStreak30Title,
        description: loc.achievementStreak30Desc,
        icon: Icons.local_fire_department_rounded,
      ),
      Achievement(
        id: AchievementId.goalHit5,
        title: loc.achievementGoalHit5Title,
        description: loc.achievementGoalHit5Desc,
        icon: Icons.flag_rounded,
      ),
      Achievement(
        id: AchievementId.goalHit30,
        title: loc.achievementGoalHit30Title,
        description: loc.achievementGoalHit30Desc,
        icon: Icons.flag_rounded,
      ),
      Achievement(
        id: AchievementId.drinksLogged50,
        title: loc.achievementDrinksLogged50Title,
        description: loc.achievementDrinksLogged50Desc,
        icon: Icons.water_drop_rounded,
      ),
    ];
