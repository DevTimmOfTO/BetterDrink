import 'package:flutter/material.dart';

import '../data/typical_sugar_drinks.dart';
import '../l10n/gen/app_localizations.dart';

typedef AddSugarDrink = void Function(
    String name, double volumeMl, double sugarPer100ml);

/// Grid of one-tap typical-sugar-drink buttons, plus a dialog for entering
/// a custom drink's name/volume/sugar concentration.
class SugarPresetGrid extends StatelessWidget {
  const SugarPresetGrid({super.key, required this.onAdd});

  final AddSugarDrink onAdd;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.4,
          children: [
            for (final drink in typicalSugarDrinks(loc))
              _PresetButton(
                drink: drink,
                onTap: () =>
                    onAdd(drink.name, drink.volumeMl, drink.sugarPer100ml),
              ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _promptCustomDrink(context, loc),
            child: Text(loc.customSugarDrinkButton),
          ),
        ),
      ],
    );
  }

  Future<void> _promptCustomDrink(BuildContext context, AppLocalizations loc) async {
    final nameController = TextEditingController();
    final volumeController = TextEditingController();
    final sugarController = TextEditingController();
    final result = await showDialog<_CustomDrinkResult>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(loc.customSugarDrinkDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration:
                    InputDecoration(hintText: loc.customSugarDrinkNameHint),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: volumeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  suffixText: loc.mlUnit,
                  hintText: loc.volumeHint,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: sugarController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  suffixText: loc.sugarPer100mlSuffix,
                  hintText: loc.sugarPer100mlHint,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(loc.cancel),
            ),
            FilledButton(
              onPressed: () {
                final volume = double.tryParse(volumeController.text);
                final sugar = double.tryParse(sugarController.text);
                if (volume == null || volume <= 0 || sugar == null || sugar < 0) {
                  Navigator.of(context).pop();
                  return;
                }
                final name = nameController.text.trim();
                Navigator.of(context).pop(
                  _CustomDrinkResult(
                      name.isEmpty ? loc.defaultDrinkName : name, volume, sugar),
                );
              },
              child: Text(loc.add),
            ),
          ],
        );
      },
    );
    if (result != null) {
      onAdd(result.name, result.volumeMl, result.sugarPer100ml);
    }
  }
}

class _CustomDrinkResult {
  const _CustomDrinkResult(this.name, this.volumeMl, this.sugarPer100ml);
  final String name;
  final double volumeMl;
  final double sugarPer100ml;
}

class _PresetButton extends StatelessWidget {
  const _PresetButton({required this.drink, required this.onTap});

  final TypicalSugarDrink drink;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            children: [
              Icon(drink.icon, color: colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      drink.name,
                      style: Theme.of(context).textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${drink.volumeMl.toStringAsFixed(0)} ml · '
                      '${drink.sugarPer100ml.toStringAsFixed(1)} g/100ml',
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
