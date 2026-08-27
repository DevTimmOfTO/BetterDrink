import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/gen/app_localizations.dart';

/// Shows a bottom sheet with a short, non-exhaustive list of well-known
/// support resources for people who want to cut down or stop drinking.
Future<void> showAlcoholHelpSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => const _AlcoholHelpSheet(),
  );
}

class _Resource {
  const _Resource({required this.name, required this.detail, required this.link});
  final String name;
  final String detail;
  final String link;
}

/// Organization names and phone numbers are proper nouns and stay
/// consistent across locales; only [_Resource.detail] is localized.
List<_Resource> _resources(AppLocalizations loc) => [
      _Resource(
        name: 'Alcoholics Anonymous',
        detail: loc.resourceAaDetail,
        link: 'aa.org',
      ),
      _Resource(
        name: 'SAMHSA National Helpline (US)',
        detail: loc.resourceSamhsaDetail,
        link: 'samhsa.gov/find-help/national-helpline',
      ),
      _Resource(
        name: 'Deutsche Hauptstelle für Suchtfragen (Germany)',
        detail: loc.resourceDhsDetail,
        link: 'dhs.de',
      ),
    ];

class _AlcoholHelpSheet extends StatelessWidget {
  const _AlcoholHelpSheet();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loc.helpSheetTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              loc.helpSheetIntro,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            for (final resource in _resources(loc)) _ResourceTile(resource: resource),
          ],
        ),
      ),
    );
  }
}

class _ResourceTile extends StatelessWidget {
  const _ResourceTile({required this.resource});

  final _Resource resource;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(resource.name),
      subtitle: Text('${resource.detail}\n${resource.link}'),
      isThreeLine: true,
      trailing: IconButton(
        icon: const Icon(Icons.copy_rounded),
        tooltip: AppLocalizations.of(context)!.copyLinkTooltip,
        onPressed: () {
          final loc = AppLocalizations.of(context)!;
          Clipboard.setData(ClipboardData(text: resource.link));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.copiedToClipboard)),
          );
        },
      ),
    );
  }
}
