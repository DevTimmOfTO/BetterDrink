// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navAlcoholFree => 'Alcohol-free';

  @override
  String get navSugar => 'Sugar';

  @override
  String get navAlcohol => 'Alcohol';

  @override
  String get navLeaderboard => 'Leaderboard';

  @override
  String get navSettings => 'Settings';

  @override
  String get homeAppBarTitle => 'BetterDrink';

  @override
  String get homeReminderDue => 'reminder due';

  @override
  String get homeUntilNextReminder => 'until next reminder';

  @override
  String get homeNow => 'Now';

  @override
  String homeTodayMl(int ml) {
    return '$ml ml today';
  }

  @override
  String homeAchievementUnlocked(String titles) {
    return 'Achievement unlocked: $titles';
  }

  @override
  String get trends => 'Trends';

  @override
  String get noTrendDataYet =>
      'No data yet — log a few days to see your trend.';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get save => 'Save';

  @override
  String get mlUnit => 'ml';

  @override
  String get customButton => 'Custom';

  @override
  String get addWaterDialogTitle => 'Add water';

  @override
  String get addWaterHint => 'e.g. 330';

  @override
  String mlAmount(int ml) {
    return '$ml ml';
  }

  @override
  String get alcoholTabTitle => 'Alcohol';

  @override
  String get getHelpTooltip => 'Get help';

  @override
  String get alcoholWarningBanner =>
      'Alcohol is a drug. It can be addictive and harmful to your health. Tap the help icon above if you\'d like support.';

  @override
  String get bacSoberLabel => '0.0‰ · sober';

  @override
  String get bacSoberHint => 'Log a drink below to start tracking.';

  @override
  String bacUntilZero(String bac) {
    return '$bac‰ · until 0.0‰';
  }

  @override
  String get bacDisclaimer =>
      'Estimate only — not medical advice. Never drive on alcohol.';

  @override
  String get logADrink => 'Log a drink';

  @override
  String get historyTitle => 'History';

  @override
  String get customDrinkButton => 'Custom drink';

  @override
  String get customDrinkDialogTitle => 'Custom drink';

  @override
  String get customDrinkNameHint => 'e.g. IPA';

  @override
  String get volumeHint => 'Volume';

  @override
  String get abvSuffix => '% ABV';

  @override
  String get abvHint => 'Alcohol strength';

  @override
  String get defaultDrinkName => 'Drink';

  @override
  String get drinkBeer => 'Beer';

  @override
  String get drinkSmallBeer => 'Small beer';

  @override
  String get drinkWine => 'Wine';

  @override
  String get drinkSparklingWine => 'Sparkling wine';

  @override
  String get drinkShotSpirit => 'Shot / spirit';

  @override
  String get drinkMixedDrink => 'Mixed drink';

  @override
  String get drinkCocktail => 'Cocktail';

  @override
  String get sugarTabTitle => 'Sugar';

  @override
  String sugarTodayGrams(String g) {
    return '$g g sugar today';
  }

  @override
  String sugarLimitWarning(String limit) {
    return 'You\'ve passed the WHO-recommended daily sugar limit of $limit g.';
  }

  @override
  String get logASugarDrink => 'Log a sugary drink';

  @override
  String get customSugarDrinkButton => 'Custom drink';

  @override
  String get customSugarDrinkDialogTitle => 'Custom drink';

  @override
  String get customSugarDrinkNameHint => 'e.g. Iced coffee';

  @override
  String get sugarPer100mlSuffix => 'g/100ml';

  @override
  String get sugarPer100mlHint => 'Sugar content';

  @override
  String get noSugarDrinksLoggedYet => 'No sugary drinks logged yet.';

  @override
  String sugarHistorySubtitle(
    String volumeMl,
    String sugarPer100ml,
    String relTime,
  ) {
    return '$volumeMl ml · $sugarPer100ml g/100ml · $relTime';
  }

  @override
  String get drinkCola => 'Cola';

  @override
  String get drinkLemonade => 'Lemonade';

  @override
  String get drinkEnergyDrink => 'Energy drink';

  @override
  String get drinkOrangeJuice => 'Orange juice';

  @override
  String get drinkIcedTea => 'Iced tea';

  @override
  String get drinkSportsDrink => 'Sports drink';

  @override
  String get helpSheetTitle => 'Need support?';

  @override
  String get helpSheetIntro =>
      'If drinking feels hard to control, you\'re not alone — these are a few starting points. If you\'re in immediate danger, contact local emergency services.';

  @override
  String get copyLinkTooltip => 'Copy link';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get resourceAaDetail => 'Peer support meetings worldwide';

  @override
  String get resourceSamhsaDetail =>
      'Free, confidential, 24/7 — 1-800-662-4357';

  @override
  String get resourceDhsDetail => 'Addiction counselling and info';

  @override
  String get noDrinksLoggedYet => 'No drinks logged yet.';

  @override
  String drinkHistorySubtitle(
    String volumeMl,
    String abvPercent,
    String relTime,
  ) {
    return '$volumeMl ml · $abvPercent% · $relTime';
  }

  @override
  String get relativeTimeJustNow => 'just now';

  @override
  String relativeTimeMinutesAgo(int m) {
    return '${m}m ago';
  }

  @override
  String relativeTimeHoursAgo(int h) {
    return '${h}h ago';
  }

  @override
  String get achievementStreak3Title => '3-day streak';

  @override
  String get achievementStreak3Desc => 'Log a drink on 3 days in a row.';

  @override
  String get achievementStreak7Title => '7-day streak';

  @override
  String get achievementStreak7Desc => 'Log a drink on 7 days in a row.';

  @override
  String get achievementStreak30Title => '30-day streak';

  @override
  String get achievementStreak30Desc => 'Log a drink on 30 days in a row.';

  @override
  String get achievementGoalHit5Title => 'Goal getter';

  @override
  String get achievementGoalHit5Desc =>
      'Hit your daily hydration goal 5 times.';

  @override
  String get achievementGoalHit30Title => 'Goal master';

  @override
  String get achievementGoalHit30Desc =>
      'Hit your daily hydration goal 30 times.';

  @override
  String get achievementDrinksLogged50Title => 'Well hydrated';

  @override
  String get achievementDrinksLogged50Desc => 'Log 50 drinks in total.';

  @override
  String get leaderboardTitle => 'Leaderboard';

  @override
  String get shareStreakTooltip => 'Share your streak';

  @override
  String get addFriendTooltip => 'Add a friend';

  @override
  String get yourStreaks => 'Your streaks';

  @override
  String get currentStreakLabel => 'Current streak';

  @override
  String get bestStreakLabel => 'Best streak';

  @override
  String daysCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n days',
      one: '$n day',
    );
    return '$_temp0';
  }

  @override
  String get achievementsTitle => 'Achievements';

  @override
  String get friendsTitle => 'Friends';

  @override
  String get friendsDescription =>
      'Compare streaks by sharing a code — nothing here syncs automatically, so re-share to refresh.';

  @override
  String get noFriendsImportedYet => 'No friends imported yet.';

  @override
  String friendSubtitle(int current, int best, String importedRel) {
    return 'current: $current · best: $best · imported $importedRel';
  }

  @override
  String get exportSheetTitle => 'Share your streak';

  @override
  String get exportSheetDescription =>
      'Generates a text code you can send a friend through any app. Nothing leaves this device unless you share it yourself.';

  @override
  String get yourNameLabel => 'Your name';

  @override
  String get copyCodeTooltip => 'Copy code';

  @override
  String get codeCopiedSnackbar => 'Code copied';

  @override
  String get importSheetTitle => 'Add a friend';

  @override
  String get importSheetDescription =>
      'Paste the code a friend shared with you.';

  @override
  String get pasteCodeHint => 'Paste code here';

  @override
  String get invalidCodeError =>
      'That code doesn\'t look right — check it and try again.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get reminderIntervalTitle => 'Reminder interval';

  @override
  String get minutesUnit => 'minutes';

  @override
  String get intervalHint => 'e.g. 45';

  @override
  String get activeHoursTitle => 'Active hours';

  @override
  String get activeHoursDescription =>
      'Reminders only fire during this window, so you won\'t be woken up at night.';

  @override
  String get fromLabel => 'From';

  @override
  String get untilLabel => 'Until';

  @override
  String get dailyGoalTitle => 'Daily hydration goal';

  @override
  String get dailyGoalDescription =>
      'Used to track goal-hit achievements on the Leaderboard tab.';

  @override
  String get dailyGoalHint => 'e.g. 2000 (500-10000)';

  @override
  String get notificationMessageTitle => 'Notification message';

  @override
  String get alcoholProfileTitle => 'Alcohol profile';

  @override
  String get alcoholProfileDescription =>
      'Used only to personalize the blood-alcohol estimate on the Alcohol tab — it never leaves your device.';

  @override
  String get maleLabel => 'Male';

  @override
  String get femaleLabel => 'Female';

  @override
  String get otherLabel => 'Other';

  @override
  String get ageLabel => 'Age';

  @override
  String get yearsUnit => 'years';

  @override
  String get weightLabel => 'Weight';

  @override
  String get kgUnit => 'kg';

  @override
  String get settingsSaved => 'Settings saved';

  @override
  String get errorEnterInterval => 'Enter a reminder interval in minutes';

  @override
  String get errorActiveWindowOrder =>
      'Active start time must be before end time';

  @override
  String errorDailyGoalRange(int min, int max) {
    return 'Enter a daily hydration goal between $min and $max ml';
  }

  @override
  String get errorAgeWeight => 'Enter a valid age and weight';

  @override
  String get notificationTitle => 'Stay hydrated 💧';

  @override
  String get notificationDefaultMessage => 'Time to drink some water 💧';

  @override
  String get notificationActionLabel => 'Drank it 💧';

  @override
  String get notificationChannelDescription => 'Reminders to drink water';
}
