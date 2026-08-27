import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';

/// Row of one-tap drink-logging buttons, plus a custom-amount option.
class QuickAddRow extends StatelessWidget {
  const QuickAddRow({super.key, required this.onAdd});

  final ValueChanged<int> onAdd;

  static const List<int> _presetsMl = [250, 500];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Row(
      children: [
        for (final ml in _presetsMl) ...[
          Expanded(
            child: FilledButton.tonal(
              onPressed: () => onAdd(ml),
              child: Text(loc.mlAmount(ml)),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: OutlinedButton(
            onPressed: () => _promptCustomAmount(context, loc),
            child: Text(loc.customButton),
          ),
        ),
      ],
    );
  }

  Future<void> _promptCustomAmount(BuildContext context, AppLocalizations loc) async {
    final controller = TextEditingController();
    final entered = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(loc.addWaterDialogTitle),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              suffixText: loc.mlUnit,
              hintText: loc.addWaterHint,
            ),
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
              child: Text(loc.add),
            ),
          ],
        );
      },
    );
    if (entered != null && entered > 0) {
      onAdd(entered);
    }
  }
}
