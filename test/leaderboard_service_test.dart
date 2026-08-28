import 'package:betterdrink/services/leaderboard_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LeaderboardService.recordDrink', () {
    test('does not reset an existing streak when called without a prior load', () async {
      // Simulates the notification background isolate: a fresh instance
      // whose in-memory fields were never populated via load(), confirming
      // a drink for a day that continues yesterday's streak.
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayKey =
          '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-'
          '${yesterday.day.toString().padLeft(2, '0')}';
      SharedPreferences.setMockInitialValues({
        'streak_current': 15,
        'streak_best': 20,
        'streak_last_date': yesterdayKey,
      });

      await LeaderboardService.instance.recordDrink();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('streak_current'), 16);
      expect(prefs.getInt('streak_best'), 20);
    });
  });
}
