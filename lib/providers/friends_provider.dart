import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/friend_snapshot.dart';
import '../services/friends_service.dart';

/// Holds imported friend streak snapshots, keeping them in sync with
/// on-device persistence.
class FriendsNotifier extends Notifier<List<FriendSnapshot>> {
  @override
  List<FriendSnapshot> build() {
    _load();
    return const [];
  }

  Future<void> _load() async {
    state = await FriendsService.instance.loadFriends();
  }

  Future<void> addFriend(FriendSnapshot friend) async {
    final updated = [friend, ...state];
    state = updated;
    await FriendsService.instance.saveFriends(updated);
  }

  Future<void> removeFriend(String id) async {
    final updated = state.where((f) => f.id != id).toList();
    state = updated;
    await FriendsService.instance.saveFriends(updated);
  }
}

final friendsProvider = NotifierProvider<FriendsNotifier, List<FriendSnapshot>>(
  FriendsNotifier.new,
);
