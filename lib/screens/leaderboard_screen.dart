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

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(leaderboardProvider);
    final unlockedAchievements = ref.watch(achievementProvider);
    final friends = ref.watch(friendsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share_rounded),
            tooltip: 'Share your streak',
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => const _ExportSheet(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person_add_alt_rounded),
            tooltip: 'Add a friend',
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
            Text('Your streaks', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.local_fire_department_rounded,
                    label: 'Current streak',
                    value: '${data.currentStreak} days',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.emoji_events_rounded,
                    label: 'Best streak',
                    value: '${data.bestStreak} days',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text('Achievements', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            AchievementGrid(unlocked: unlockedAchievements),
            const SizedBox(height: 28),
            Text('Friends', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Compare streaks by sharing a code — nothing here syncs '
              'automatically, so re-share to refresh.',
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

  Future<void> _copyCode(String name, String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    await FriendsService.instance.saveOwnDisplayName(name);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code copied')),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          Text('Share your streak', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Generates a text code you can send a friend through any app. '
            'Nothing leaves this device unless you share it yourself.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Your name'),
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
                  tooltip: 'Copy code',
                  onPressed: () => _copyCode(name, code),
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

  Future<void> _save() async {
    final snapshot = decodeStreakCode(_codeController.text);
    if (snapshot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('That code doesn\'t look right — check it and try again.'),
        ),
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
          Text('Add a friend', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Paste the code a friend shared with you.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _codeController,
            maxLines: 3,
            decoration: const InputDecoration(hintText: 'Paste code here'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _save,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
