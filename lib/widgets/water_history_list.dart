import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';
import '../models/water_entry.dart';
import '../services/relative_time.dart';

/// List of previously logged water entries, most recent first. Swipe to
/// delete a mistaken entry, tap to correct its amount.
class WaterHistoryList extends StatelessWidget {
  const WaterHistoryList({
    super.key,
    required this.entries,
    required this.onDelete,
    required this.onEdit,
  });

  final List<WaterEntry> entries;
  final ValueChanged<String> onDelete;
  final void Function(String id, int volumeMl) onEdit;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    if (entries.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            loc.noWaterLoggedYet,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }
    return Column(
      children: [
        for (final entry in entries)
          Dismissible(
            key: ValueKey(entry.id),
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
            onDismissed: (_) => onDelete(entry.id),
            child: Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.water_drop_rounded),
                title: Text(loc.mlAmount(entry.volumeMl)),
                subtitle: Text(formatRelativeTime(entry.timestamp, loc)),
                trailing: const Icon(Icons.edit_outlined),
                onTap: () => _promptEdit(context, loc, entry),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _promptEdit(
    BuildContext context,
    AppLocalizations loc,
    WaterEntry entry,
  ) async {
    final controller =
        TextEditingController(text: entry.volumeMl.toString());
    final entered = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(loc.editWaterDialogTitle),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(suffixText: loc.mlUnit),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(loc.cancel),
            ),
            FilledButton(
              onPressed: () {
                final value = int.tryParse(controller.text);
                Navigator.of(context).pop(value);
              },
              child: Text(loc.save),
            ),
          ],
        );
      },
    );
    if (entered != null && entered > 0) {
      onEdit(entry.id, entered);
    }
  }
}
