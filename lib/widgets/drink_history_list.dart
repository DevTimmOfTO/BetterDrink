import 'package:flutter/material.dart';

import '../models/drink_entry.dart';

/// List of previously logged drinks, most recent first. Swipe to delete a
/// mistaken entry.
class DrinkHistoryList extends StatelessWidget {
  const DrinkHistoryList({
    super.key,
    required this.drinks,
    required this.onDelete,
  });

  final List<DrinkEntry> drinks;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    if (drinks.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'No drinks logged yet.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }
    return Column(
      children: [
        for (final drink in drinks)
          Dismissible(
            key: ValueKey(drink.id),
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
            onDismissed: (_) => onDelete(drink.id),
            child: Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                title: Text(drink.name),
                subtitle: Text(
                  '${drink.volumeMl.toStringAsFixed(0)} ml · '
                  '${drink.abvPercent.toStringAsFixed(0)}% · '
                  '${_formatTime(drink.timestamp)}',
                ),
              ),
            ),
          ),
      ],
    );
  }
}

String _formatTime(DateTime time) {
  final now = DateTime.now();
  final diff = now.difference(time);
  if (diff.inMinutes < 1) return 'just now';
  if (diff.inHours < 1) return '${diff.inMinutes}m ago';
  if (diff.inDays < 1) return '${diff.inHours}h ago';
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '${time.day}.${time.month}. $hour:$minute';
}
