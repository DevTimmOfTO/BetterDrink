import 'package:flutter/material.dart';

import '../models/achievement.dart';

/// Two-column grid of achievement cards, styled like the leaderboard's
/// stat cards. Locked achievements are dimmed with a lock icon in place of
/// their real icon.
class AchievementGrid extends StatelessWidget {
  const AchievementGrid({super.key, required this.unlocked});

  final Set<AchievementId> unlocked;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final cardWidth = (constraints.maxWidth - spacing) / 2;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final achievement in achievementCatalog)
              SizedBox(
                width: cardWidth,
                child: _AchievementCard(
                  achievement: achievement,
                  unlocked: unlocked.contains(achievement.id),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.achievement, required this.unlocked});

  final Achievement achievement;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Opacity(
      opacity: unlocked ? 1 : 0.4,
      child: Material(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                unlocked ? achievement.icon : Icons.lock_rounded,
                color: unlocked ? colorScheme.primary : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      achievement.title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      achievement.description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
