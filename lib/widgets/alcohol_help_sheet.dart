import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class _AlcoholHelpSheet extends StatelessWidget {
  const _AlcoholHelpSheet();

  static const _resources = [
    _Resource(
      name: 'Alcoholics Anonymous',
      detail: 'Peer support meetings worldwide',
      link: 'aa.org',
    ),
    _Resource(
      name: 'SAMHSA National Helpline (US)',
      detail: 'Free, confidential, 24/7 — 1-800-662-4357',
      link: 'samhsa.gov/find-help/national-helpline',
    ),
    _Resource(
      name: 'Deutsche Hauptstelle für Suchtfragen (Germany)',
      detail: 'Addiction counselling and info',
      link: 'dhs.de',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Need support?', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'If drinking feels hard to control, you\'re not alone — these '
              'are a few starting points. If you\'re in immediate danger, '
              'contact local emergency services.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            for (final resource in _resources) _ResourceTile(resource: resource),
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
        tooltip: 'Copy link',
        onPressed: () {
          Clipboard.setData(ClipboardData(text: resource.link));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Copied to clipboard')),
          );
        },
      ),
    );
  }
}
