import 'package:flutter/material.dart';

import '../data/typical_drinks.dart';
import '../l10n/gen/app_localizations.dart';

typedef AddDrink = void Function(
    String name, double volumeMl, double abvPercent);

/// Grid of one-tap typical-drink buttons, plus a dialog for entering a
/// custom drink's name/volume/strength.
class DrinkPresetGrid extends StatelessWidget {
  const DrinkPresetGrid({super.key, required this.onAdd});

  final AddDrink onAdd;

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
            for (final drink in typicalDrinks(loc))
              _PresetButton(
                drink: drink,
                onTap: () => onAdd(drink.name, drink.volumeMl, drink.abvPercent),
              ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _promptCustomDrink(context, loc),
            child: Text(loc.customDrinkButton),
          ),
        ),
      ],
    );
  }

  Future<void> _promptCustomDrink(BuildContext context, AppLocalizations loc) async {
    final nameController = TextEditingController();
    final volumeController = TextEditingController();
    final abvController = TextEditingController();
    final result = await showDialog<_CustomDrinkResult>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(loc.customDrinkDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: loc.customDrinkNameHint),
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
                controller: abvController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  suffixText: loc.abvSuffix,
                  hintText: loc.abvHint,
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
                final abv = double.tryParse(abvController.text);
                if (volume == null || volume <= 0 || abv == null || abv <= 0) {
                  Navigator.of(context).pop();
                  return;
                }
                final name = nameController.text.trim();
                Navigator.of(context).pop(
                  _CustomDrinkResult(name.isEmpty ? loc.defaultDrinkName : name, volume, abv),
                );
              },
              child: Text(loc.add),
            ),
          ],
        );
      },
    );
    if (result != null) {
      onAdd(result.name, result.volumeMl, result.abvPercent);
    }
  }
}

class _CustomDrinkResult {
  const _CustomDrinkResult(this.name, this.volumeMl, this.abvPercent);
  final String name;
  final double volumeMl;
  final double abvPercent;
}

class _PresetButton extends StatelessWidget {
  const _PresetButton({required this.drink, required this.onTap});

  final TypicalDrink drink;
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
                      '${drink.abvPercent.toStringAsFixed(0)}%',
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
