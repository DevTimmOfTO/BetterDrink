import 'dart:async';

import 'package:flutter/material.dart';

import '../data/beverage_servings.dart';
import '../l10n/gen/app_localizations.dart';
import '../models/beverage_kind.dart';

/// How long an opened serving panel stays up before folding itself away, so
/// a stray tap doesn't leave the tab expanded indefinitely.
const Duration _autoCollapseAfter = Duration(seconds: 30);

const Duration _fadeDuration = Duration(milliseconds: 250);

/// One row of drink-kind buttons (coffee, tea, water). Tapping one reveals
/// that kind's serving sizes directly underneath; the panel fades back out
/// after [_autoCollapseAfter], after logging, or when its button is tapped
/// again.
class BeverageQuickAdd extends StatefulWidget {
  const BeverageQuickAdd({super.key, required this.onAdd});

  final void Function(int volumeMl, BeverageKind kind) onAdd;

  @override
  State<BeverageQuickAdd> createState() => _BeverageQuickAddState();
}

class _BeverageQuickAddState extends State<BeverageQuickAdd> {
  BeverageKind? _openKind;
  Timer? _autoCollapse;

  @override
  void dispose() {
    _autoCollapse?.cancel();
    super.dispose();
  }

  void _toggle(BeverageKind kind) {
    if (_openKind == kind) {
      _collapse();
      return;
    }
    setState(() => _openKind = kind);
    _restartAutoCollapse();
  }

  void _restartAutoCollapse() {
    _autoCollapse?.cancel();
    _autoCollapse = Timer(_autoCollapseAfter, _collapse);
  }

  void _collapse() {
    _autoCollapse?.cancel();
    _autoCollapse = null;
    if (mounted) setState(() => _openKind = null);
  }

  void _log(int volumeMl, BeverageKind kind) {
    widget.onAdd(volumeMl, kind);
    _collapse();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final openKind = _openKind;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            for (final kind in const [
              BeverageKind.coffee,
              BeverageKind.tea,
              BeverageKind.water,
            ]) ...[
              Expanded(
                child: _KindButton(
                  kind: kind,
                  selected: kind == openKind,
                  onPressed: () => _toggle(kind),
                ),
              ),
              if (kind != BeverageKind.water) const SizedBox(width: 12),
            ],
          ],
        ),
        // AnimatedSize handles the height change, AnimatedSwitcher the
        // cross-fade -- together they give the panel a single fade-and-grow
        // in and fade-and-shrink out.
        AnimatedSize(
          duration: _fadeDuration,
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: AnimatedSwitcher(
            duration: _fadeDuration,
            layoutBuilder: (currentChild, previousChildren) => Stack(
              alignment: Alignment.topCenter,
              children: [...previousChildren, ?currentChild],
            ),
            child: openKind == null
                ? const SizedBox(width: double.infinity)
                : _ServingPanel(
                    key: ValueKey(openKind),
                    kind: openKind,
                    loc: loc,
                    onPick: (ml) => _log(ml, openKind),
                    onCustomPressed: () => _promptCustomAmount(openKind, loc),
                  ),
          ),
        ),
      ],
    );
  }

  /// Opens the free-entry amount dialog. The auto-collapse timer is stopped
  /// while the dialog is up so the panel isn't yanked away underneath it,
  /// and restarted if the user backs out without logging.
  Future<void> _promptCustomAmount(
    BeverageKind kind,
    AppLocalizations loc,
  ) async {
    _autoCollapse?.cancel();
    final controller = TextEditingController();
    final entered = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(loc.addBeverageDialogTitle(kind.label(loc))),
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
    if (!mounted) return;
    if (entered != null && entered > 0) {
      _log(entered, kind);
    } else {
      _restartAutoCollapse();
    }
  }
}

class _KindButton extends StatelessWidget {
  const _KindButton({
    required this.kind,
    required this.selected,
    required this.onPressed,
  });

  final BeverageKind kind;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final label = Text(
      kind.label(loc),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    return selected
        ? FilledButton.tonalIcon(
            onPressed: onPressed,
            icon: Icon(kind.icon),
            label: label,
          )
        : OutlinedButton.icon(
            onPressed: onPressed,
            icon: Icon(kind.icon),
            label: label,
          );
  }
}

/// The serving sizes revealed under a selected drink kind.
class _ServingPanel extends StatelessWidget {
  const _ServingPanel({
    super.key,
    required this.kind,
    required this.loc,
    required this.onPick,
    required this.onCustomPressed,
  });

  final BeverageKind kind;
  final AppLocalizations loc;
  final ValueChanged<int> onPick;
  final VoidCallback onCustomPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final factorNote = kind.factorNote(loc);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final serving in servingsFor(kind, loc))
                  ActionChip(
                    avatar: Icon(kind.icon, size: 18),
                    label: Text('${serving.label} · ${serving.volumeMl} ${loc.mlUnit}'),
                    onPressed: () => onPick(serving.volumeMl),
                  ),
                ActionChip(
                  avatar: const Icon(Icons.tune_rounded, size: 18),
                  label: Text(loc.customButton),
                  onPressed: onCustomPressed,
                ),
              ],
            ),
            if (factorNote != null) ...[
              const SizedBox(height: 10),
              Text(
                factorNote,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
