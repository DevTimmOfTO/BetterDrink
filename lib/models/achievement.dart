import 'package:flutter/material.dart';

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

const List<Achievement> achievementCatalog = [
  Achievement(
    id: AchievementId.streak3,
    title: '3-day streak',
    description: 'Log a drink on 3 days in a row.',
    icon: Icons.local_fire_department_rounded,
  ),
  Achievement(
    id: AchievementId.streak7,
    title: '7-day streak',
    description: 'Log a drink on 7 days in a row.',
    icon: Icons.local_fire_department_rounded,
  ),
  Achievement(
    id: AchievementId.streak30,
    title: '30-day streak',
    description: 'Log a drink on 30 days in a row.',
    icon: Icons.local_fire_department_rounded,
  ),
  Achievement(
    id: AchievementId.goalHit5,
    title: 'Goal getter',
    description: 'Hit your daily hydration goal 5 times.',
    icon: Icons.flag_rounded,
  ),
  Achievement(
    id: AchievementId.goalHit30,
    title: 'Goal master',
    description: 'Hit your daily hydration goal 30 times.',
    icon: Icons.flag_rounded,
  ),
  Achievement(
    id: AchievementId.drinksLogged50,
    title: 'Well hydrated',
    description: 'Log 50 drinks in total.',
    icon: Icons.water_drop_rounded,
  ),
];
