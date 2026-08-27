import 'package:betterdrink/models/friend_snapshot.dart';
import 'package:betterdrink/providers/achievement_provider.dart';
import 'package:betterdrink/providers/friends_provider.dart';
import 'package:betterdrink/providers/leaderboard_provider.dart';
import 'package:betterdrink/services/friends_service.dart';
import 'package:betterdrink/services/streak_code.dart';
import 'package:betterdrink/widgets/achievement_grid.dart';
import 'package:betterdrink/widgets/friend_snapshot_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/gen/app_localizations.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final data = ref.watch(leaderboardProvider);
    final unlockedAchievements = ref.watch(achievementProvider);
    final friends = ref.watch(friendsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.leaderboardTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share_rounded),
            tooltip: loc.shareStreakTooltip,
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => const _ExportSheet(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person_add_alt_rounded),
            tooltip: loc.addFriendTooltip,
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => const _ImportSheet(),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(loc.yourStreaks, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.local_fire_department_rounded,
                    label: loc.currentStreakLabel,
                    value: loc.daysCount(data.currentStreak),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.emoji_events_rounded,
                    label: loc.bestStreakLabel,
                    value: loc.daysCount(data.bestStreak),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(loc.achievementsTitle, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            AchievementGrid(unlocked: unlockedAchievements),
            const SizedBox(height: 28),
            Text(loc.friendsTitle, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              loc.friendsDescription,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            FriendSnapshotList(
              friends: friends,
              onRemove: (id) => ref.read(friendsProvider.notifier).removeFriend(id),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet that turns the local streak into a copyable text code.
/// The entered name is remembered locally so it doesn't need retyping.
class _ExportSheet extends ConsumerStatefulWidget {
  const _ExportSheet();

  @override
  ConsumerState<_ExportSheet> createState() => _ExportSheetState();
}

class _ExportSheetState extends ConsumerState<_ExportSheet> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _loadName();
  }

  Future<void> _loadName() async {
    final name = await FriendsService.instance.loadOwnDisplayName();
    if (!mounted) return;
    setState(() => _nameController.text = name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _copyCode(String name, String code, AppLocalizations loc) async {
    await Clipboard.setData(ClipboardData(text: code));
    await FriendsService.instance.saveOwnDisplayName(name);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.codeCopiedSnackbar)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final leaderboard = ref.watch(leaderboardProvider);
    final name = _nameController.text.trim();
    final code = name.isEmpty
        ? null
        : encodeStreakCode(
            displayName: name,
            currentStreak: leaderboard.currentStreak,
            bestStreak: leaderboard.bestStreak,
            asOf: DateTime.now(),
          );

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loc.exportSheetTitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            loc.exportSheetDescription,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: loc.yourNameLabel),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          if (code != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SelectableText(code, style: Theme.of(context).textTheme.bodySmall),
                ),
                IconButton(
                  icon: const Icon(Icons.copy_rounded),
                  tooltip: loc.copyCodeTooltip,
                  onPressed: () => _copyCode(name, code, loc),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// Bottom sheet that decodes a pasted streak-share code and saves it as a
/// [FriendSnapshot].
class _ImportSheet extends ConsumerStatefulWidget {
  const _ImportSheet();

  @override
  ConsumerState<_ImportSheet> createState() => _ImportSheetState();
}

class _ImportSheetState extends ConsumerState<_ImportSheet> {
  late final TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _save(AppLocalizations loc) async {
    final snapshot = decodeStreakCode(_codeController.text);
    if (snapshot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.invalidCodeError)),
      );
      return;
    }
    await ref.read(friendsProvider.notifier).addFriend(
          FriendSnapshot(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            displayName: snapshot.displayName,
            currentStreak: snapshot.currentStreak,
            bestStreak: snapshot.bestStreak,
            importedAt: DateTime.now(),
          ),
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loc.importSheetTitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            loc.importSheetDescription,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _codeController,
            maxLines: 3,
            decoration: InputDecoration(hintText: loc.pasteCodeHint),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => _save(loc),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(loc.save),
            ),
          ),
        ],
      ),
    );
  }
}
