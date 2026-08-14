import 'package:flutter/material.dart';

/// Row of one-tap drink-logging buttons, plus a custom-amount option.
class QuickAddRow extends StatelessWidget {
  const QuickAddRow({super.key, required this.onAdd});

  final ValueChanged<int> onAdd;

  static const List<int> _presetsMl = [250, 500];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final ml in _presetsMl) ...[
          Expanded(
            child: FilledButton.tonal(
              onPressed: () => onAdd(ml),
              child: Text('$ml ml'),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: OutlinedButton(
            onPressed: () => _promptCustomAmount(context),
            child: const Text('Custom'),
          ),
        ),
      ],
    );
  }

  Future<void> _promptCustomAmount(BuildContext context) async {
    final controller = TextEditingController();
    final entered = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add water'),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              suffixText: 'ml',
              hintText: 'e.g. 330',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final value = int.tryParse(controller.text);
                Navigator.of(context).pop(value);
              },
              child: const Text('Add'),
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
