import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/friend_snapshot.dart';

/// Persists imported friend streak snapshots. Purely local — snapshots
/// only enter via a user manually pasting a code shared through some
/// other app; nothing here ever makes a network call.
class FriendsService {
  FriendsService._();
  static final FriendsService instance = FriendsService._();

  static const _keyFriends = 'friends_snapshots';
  static const _keyOwnDisplayName = 'friends_own_display_name';

  /// The name shown to friends when they import a code exported from this
  /// device — remembered locally so it doesn't need retyping every time.
  Future<String> loadOwnDisplayName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyOwnDisplayName) ?? '';
  }

  Future<void> saveOwnDisplayName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyOwnDisplayName, name);
  }

  Future<List<FriendSnapshot>> loadFriends() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_keyFriends) ?? const [];
    return raw
        .map((e) => FriendSnapshot.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveFriends(List<FriendSnapshot> friends) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _keyFriends,
      friends.map((f) => jsonEncode(f.toJson())).toList(),
    );
  }
}
