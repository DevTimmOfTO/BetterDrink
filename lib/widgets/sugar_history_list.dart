import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';
import '../models/sugar_entry.dart';
import '../services/relative_time.dart';

/// List of previously logged sugary drinks, most recent first. Swipe to
/// delete a mistaken entry.
class SugarHistoryList extends StatelessWidget {
  const SugarHistoryList({
    super.key,
    required this.drinks,
    required this.onDelete,
  });

  final List<SugarEntry> drinks;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    if (drinks.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            loc.noSugarDrinksLoggedYet,
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
                  loc.sugarHistorySubtitle(
                    drink.volumeMl.toStringAsFixed(0),
                    drink.sugarPer100ml.toStringAsFixed(1),
                    formatRelativeTime(drink.timestamp, loc),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
