import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @navAlcoholFree.
  ///
  /// In en, this message translates to:
  /// **'Alcohol-free'**
  String get navAlcoholFree;

  /// No description provided for @navAlcohol.
  ///
  /// In en, this message translates to:
  /// **'Alcohol'**
  String get navAlcohol;

  /// No description provided for @navLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get navLeaderboard;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @homeAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'BetterDrink'**
  String get homeAppBarTitle;

  /// No description provided for @homeReminderDue.
  ///
  /// In en, this message translates to:
  /// **'reminder due'**
  String get homeReminderDue;

  /// No description provided for @homeUntilNextReminder.
  ///
  /// In en, this message translates to:
  /// **'until next reminder'**
  String get homeUntilNextReminder;

  /// No description provided for @homeNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get homeNow;

  /// No description provided for @homeTodayMl.
  ///
  /// In en, this message translates to:
  /// **'{ml} ml today'**
  String homeTodayMl(int ml);

  /// No description provided for @homeAchievementUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Achievement unlocked: {titles}'**
  String homeAchievementUnlocked(String titles);

  /// No description provided for @trends.
  ///
  /// In en, this message translates to:
  /// **'Trends'**
  String get trends;

  /// No description provided for @noTrendDataYet.
  ///
  /// In en, this message translates to:
  /// **'No data yet — log a few days to see your trend.'**
  String get noTrendDataYet;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @mlUnit.
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get mlUnit;

  /// No description provided for @customButton.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customButton;

  /// No description provided for @addWaterDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Add water'**
  String get addWaterDialogTitle;

  /// No description provided for @addWaterHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 330'**
  String get addWaterHint;

  /// No description provided for @mlAmount.
  ///
  /// In en, this message translates to:
  /// **'{ml} ml'**
  String mlAmount(int ml);

  /// No description provided for @alcoholTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Alcohol'**
  String get alcoholTabTitle;

  /// No description provided for @getHelpTooltip.
  ///
  /// In en, this message translates to:
  /// **'Get help'**
  String get getHelpTooltip;

  /// No description provided for @alcoholWarningBanner.
  ///
  /// In en, this message translates to:
  /// **'Alcohol is a drug. It can be addictive and harmful to your health. Tap the help icon above if you\'d like support.'**
  String get alcoholWarningBanner;

  /// No description provided for @bacSoberLabel.
  ///
  /// In en, this message translates to:
  /// **'0.0‰ · sober'**
  String get bacSoberLabel;

  /// No description provided for @bacSoberHint.
  ///
  /// In en, this message translates to:
  /// **'Log a drink below to start tracking.'**
  String get bacSoberHint;

  /// No description provided for @bacUntilZero.
  ///
  /// In en, this message translates to:
  /// **'{bac}‰ · until 0.0‰'**
  String bacUntilZero(String bac);

  /// No description provided for @bacDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Estimate only — not medical advice. Never drive on alcohol.'**
  String get bacDisclaimer;

  /// No description provided for @logADrink.
  ///
  /// In en, this message translates to:
  /// **'Log a drink'**
  String get logADrink;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @customDrinkButton.
  ///
  /// In en, this message translates to:
  /// **'Custom drink'**
  String get customDrinkButton;

  /// No description provided for @customDrinkDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom drink'**
  String get customDrinkDialogTitle;

  /// No description provided for @customDrinkNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. IPA'**
  String get customDrinkNameHint;

  /// No description provided for @volumeHint.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volumeHint;

  /// No description provided for @abvSuffix.
  ///
  /// In en, this message translates to:
  /// **'% ABV'**
  String get abvSuffix;

  /// No description provided for @abvHint.
  ///
  /// In en, this message translates to:
  /// **'Alcohol strength'**
  String get abvHint;

  /// No description provided for @defaultDrinkName.
  ///
  /// In en, this message translates to:
  /// **'Drink'**
  String get defaultDrinkName;

  /// No description provided for @drinkBeer.
  ///
  /// In en, this message translates to:
  /// **'Beer'**
  String get drinkBeer;

  /// No description provided for @drinkSmallBeer.
  ///
  /// In en, this message translates to:
  /// **'Small beer'**
  String get drinkSmallBeer;

  /// No description provided for @drinkWine.
  ///
  /// In en, this message translates to:
  /// **'Wine'**
  String get drinkWine;

  /// No description provided for @drinkSparklingWine.
  ///
  /// In en, this message translates to:
  /// **'Sparkling wine'**
  String get drinkSparklingWine;

  /// No description provided for @drinkShotSpirit.
  ///
  /// In en, this message translates to:
  /// **'Shot / spirit'**
  String get drinkShotSpirit;

  /// No description provided for @drinkMixedDrink.
  ///
  /// In en, this message translates to:
  /// **'Mixed drink'**
  String get drinkMixedDrink;

  /// No description provided for @drinkCocktail.
  ///
  /// In en, this message translates to:
  /// **'Cocktail'**
  String get drinkCocktail;

  /// No description provided for @helpSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Need support?'**
  String get helpSheetTitle;

  /// No description provided for @helpSheetIntro.
  ///
  /// In en, this message translates to:
  /// **'If drinking feels hard to control, you\'re not alone — these are a few starting points. If you\'re in immediate danger, contact local emergency services.'**
  String get helpSheetIntro;

  /// No description provided for @copyLinkTooltip.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get copyLinkTooltip;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @resourceAaDetail.
  ///
  /// In en, this message translates to:
  /// **'Peer support meetings worldwide'**
  String get resourceAaDetail;

  /// No description provided for @resourceSamhsaDetail.
  ///
  /// In en, this message translates to:
  /// **'Free, confidential, 24/7 — 1-800-662-4357'**
  String get resourceSamhsaDetail;

  /// No description provided for @resourceDhsDetail.
  ///
  /// In en, this message translates to:
  /// **'Addiction counselling and info'**
  String get resourceDhsDetail;

  /// No description provided for @noDrinksLoggedYet.
  ///
  /// In en, this message translates to:
  /// **'No drinks logged yet.'**
  String get noDrinksLoggedYet;

  /// No description provided for @drinkHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'{volumeMl} ml · {abvPercent}% · {relTime}'**
  String drinkHistorySubtitle(
    String volumeMl,
    String abvPercent,
    String relTime,
  );

  /// No description provided for @relativeTimeJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get relativeTimeJustNow;

  /// No description provided for @relativeTimeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{m}m ago'**
  String relativeTimeMinutesAgo(int m);

  /// No description provided for @relativeTimeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{h}h ago'**
  String relativeTimeHoursAgo(int h);

  /// No description provided for @achievementStreak3Title.
  ///
  /// In en, this message translates to:
  /// **'3-day streak'**
  String get achievementStreak3Title;

  /// No description provided for @achievementStreak3Desc.
  ///
  /// In en, this message translates to:
  /// **'Log a drink on 3 days in a row.'**
  String get achievementStreak3Desc;

  /// No description provided for @achievementStreak7Title.
  ///
  /// In en, this message translates to:
  /// **'7-day streak'**
  String get achievementStreak7Title;

  /// No description provided for @achievementStreak7Desc.
  ///
  /// In en, this message translates to:
  /// **'Log a drink on 7 days in a row.'**
  String get achievementStreak7Desc;

  /// No description provided for @achievementStreak30Title.
  ///
  /// In en, this message translates to:
  /// **'30-day streak'**
  String get achievementStreak30Title;

  /// No description provided for @achievementStreak30Desc.
  ///
  /// In en, this message translates to:
  /// **'Log a drink on 30 days in a row.'**
  String get achievementStreak30Desc;

  /// No description provided for @achievementGoalHit5Title.
  ///
  /// In en, this message translates to:
  /// **'Goal getter'**
  String get achievementGoalHit5Title;

  /// No description provided for @achievementGoalHit5Desc.
  ///
  /// In en, this message translates to:
  /// **'Hit your daily hydration goal 5 times.'**
  String get achievementGoalHit5Desc;

  /// No description provided for @achievementGoalHit30Title.
  ///
  /// In en, this message translates to:
  /// **'Goal master'**
  String get achievementGoalHit30Title;

  /// No description provided for @achievementGoalHit30Desc.
  ///
  /// In en, this message translates to:
  /// **'Hit your daily hydration goal 30 times.'**
  String get achievementGoalHit30Desc;

  /// No description provided for @achievementDrinksLogged50Title.
  ///
  /// In en, this message translates to:
  /// **'Well hydrated'**
  String get achievementDrinksLogged50Title;

  /// No description provided for @achievementDrinksLogged50Desc.
  ///
  /// In en, this message translates to:
  /// **'Log 50 drinks in total.'**
  String get achievementDrinksLogged50Desc;

  /// No description provided for @leaderboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboardTitle;

  /// No description provided for @shareStreakTooltip.
  ///
  /// In en, this message translates to:
  /// **'Share your streak'**
  String get shareStreakTooltip;

  /// No description provided for @addFriendTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add a friend'**
  String get addFriendTooltip;

  /// No description provided for @yourStreaks.
  ///
  /// In en, this message translates to:
  /// **'Your streaks'**
  String get yourStreaks;

  /// No description provided for @currentStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Current streak'**
  String get currentStreakLabel;

  /// No description provided for @bestStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Best streak'**
  String get bestStreakLabel;

  /// No description provided for @daysCount.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, one {{n} day} other {{n} days}}'**
  String daysCount(int n);

  /// No description provided for @achievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsTitle;

  /// No description provided for @friendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friendsTitle;

  /// No description provided for @friendsDescription.
  ///
  /// In en, this message translates to:
  /// **'Compare streaks by sharing a code — nothing here syncs automatically, so re-share to refresh.'**
  String get friendsDescription;

  /// No description provided for @noFriendsImportedYet.
  ///
  /// In en, this message translates to:
  /// **'No friends imported yet.'**
  String get noFriendsImportedYet;

  /// No description provided for @friendSubtitle.
  ///
  /// In en, this message translates to:
  /// **'current: {current} · best: {best} · imported {importedRel}'**
  String friendSubtitle(int current, int best, String importedRel);

  /// No description provided for @exportSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Share your streak'**
  String get exportSheetTitle;

  /// No description provided for @exportSheetDescription.
  ///
  /// In en, this message translates to:
  /// **'Generates a text code you can send a friend through any app. Nothing leaves this device unless you share it yourself.'**
  String get exportSheetDescription;

  /// No description provided for @yourNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourNameLabel;

  /// No description provided for @copyCodeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Copy code'**
  String get copyCodeTooltip;

  /// No description provided for @codeCopiedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Code copied'**
  String get codeCopiedSnackbar;

  /// No description provided for @importSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a friend'**
  String get importSheetTitle;

  /// No description provided for @importSheetDescription.
  ///
  /// In en, this message translates to:
  /// **'Paste the code a friend shared with you.'**
  String get importSheetDescription;

  /// No description provided for @pasteCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Paste code here'**
  String get pasteCodeHint;

  /// No description provided for @invalidCodeError.
  ///
  /// In en, this message translates to:
  /// **'That code doesn\'t look right — check it and try again.'**
  String get invalidCodeError;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @reminderIntervalTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder interval'**
  String get reminderIntervalTitle;

  /// No description provided for @minutesUnit.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutesUnit;

  /// No description provided for @intervalHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 45'**
  String get intervalHint;

  /// No description provided for @activeHoursTitle.
  ///
  /// In en, this message translates to:
  /// **'Active hours'**
  String get activeHoursTitle;

  /// No description provided for @activeHoursDescription.
  ///
  /// In en, this message translates to:
  /// **'Reminders only fire during this window, so you won\'t be woken up at night.'**
  String get activeHoursDescription;

  /// No description provided for @fromLabel.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get fromLabel;

  /// No description provided for @untilLabel.
  ///
  /// In en, this message translates to:
  /// **'Until'**
  String get untilLabel;

  /// No description provided for @dailyGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily hydration goal'**
  String get dailyGoalTitle;

  /// No description provided for @dailyGoalDescription.
  ///
  /// In en, this message translates to:
  /// **'Used to track goal-hit achievements on the Leaderboard tab.'**
  String get dailyGoalDescription;

  /// No description provided for @dailyGoalHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 2000 (500-10000)'**
  String get dailyGoalHint;

  /// No description provided for @notificationMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification message'**
  String get notificationMessageTitle;

  /// No description provided for @alcoholProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Alcohol profile'**
  String get alcoholProfileTitle;

  /// No description provided for @alcoholProfileDescription.
  ///
  /// In en, this message translates to:
  /// **'Used only to personalize the blood-alcohol estimate on the Alcohol tab — it never leaves your device.'**
  String get alcoholProfileDescription;

  /// No description provided for @maleLabel.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get maleLabel;

  /// No description provided for @femaleLabel.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get femaleLabel;

  /// No description provided for @otherLabel.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherLabel;

  /// No description provided for @ageLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get ageLabel;

  /// No description provided for @yearsUnit.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get yearsUnit;

  /// No description provided for @weightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightLabel;

  /// No description provided for @kgUnit.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kgUnit;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSaved;

  /// No description provided for @errorEnterInterval.
  ///
  /// In en, this message translates to:
  /// **'Enter a reminder interval in minutes'**
  String get errorEnterInterval;

  /// No description provided for @errorActiveWindowOrder.
  ///
  /// In en, this message translates to:
  /// **'Active start time must be before end time'**
  String get errorActiveWindowOrder;

  /// No description provided for @errorDailyGoalRange.
  ///
  /// In en, this message translates to:
  /// **'Enter a daily hydration goal between {min} and {max} ml'**
  String errorDailyGoalRange(int min, int max);

  /// No description provided for @errorAgeWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid age and weight'**
  String get errorAgeWeight;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay hydrated 💧'**
  String get notificationTitle;

  /// No description provided for @notificationDefaultMessage.
  ///
  /// In en, this message translates to:
  /// **'Time to drink some water 💧'**
  String get notificationDefaultMessage;

  /// No description provided for @notificationActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Drank it 💧'**
  String get notificationActionLabel;

  /// No description provided for @notificationChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Reminders to drink water'**
  String get notificationChannelDescription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
