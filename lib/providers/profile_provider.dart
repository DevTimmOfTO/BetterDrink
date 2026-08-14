import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile.dart';
import '../services/alcohol_service.dart';

/// Holds the current [UserProfile], keeping it in sync with on-device
/// persistence.
class ProfileNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() {
    _load();
    return UserProfile.defaults;
  }

  Future<void> _load() async {
    state = await AlcoholService.instance.loadProfile();
  }

  /// Persists [profile]; used only to personalize the alcohol BAC estimate.
  Future<void> update(UserProfile profile) async {
    state = profile;
    await AlcoholService.instance.saveProfile(profile);
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, UserProfile>(
  ProfileNotifier.new,
);
