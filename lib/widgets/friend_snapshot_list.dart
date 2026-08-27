import 'package:flutter/material.dart';

import '../models/friend_snapshot.dart';
import '../services/relative_time.dart';

/// List of imported friend streak snapshots, most recently imported first.
/// Swipe to remove one. Each snapshot is a point-in-time copy — the
/// subtitle always shows when it was imported so stale data reads as
/// stale.
class FriendSnapshotList extends StatelessWidget {
  const FriendSnapshotList({
    super.key,
    required this.friends,
    required this.onRemove,
  });

  final List<FriendSnapshot> friends;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    if (friends.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'No friends imported yet.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }
    return Column(
      children: [
        for (final friend in friends)
          Dismissible(
            key: ValueKey(friend.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
            onDismissed: (_) => onRemove(friend.id),
            child: Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                title: Text(friend.displayName),
                subtitle: Text(
                  'current: ${friend.currentStreak} · best: ${friend.bestStreak} · '
                  'imported ${formatRelativeTime(friend.importedAt)}',
                ),
              ),
            ),
          ),
      ],
    );
  }
}
