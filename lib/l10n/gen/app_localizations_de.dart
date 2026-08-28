// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get navAlcoholFree => 'Alkoholfrei';

  @override
  String get navSugar => 'Zucker';

  @override
  String get navAlcohol => 'Alkohol';

  @override
  String get navLeaderboard => 'Bestenliste';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get homeAppBarTitle => 'BetterDrink';

  @override
  String get homeReminderDue => 'Erinnerung fällig';

  @override
  String get homeUntilNextReminder => 'bis zur nächsten Erinnerung';

  @override
  String get homeNow => 'Jetzt';

  @override
  String homeTodayMl(int ml) {
    return '$ml ml heute';
  }

  @override
  String homeAchievementUnlocked(String titles) {
    return 'Erfolg freigeschaltet: $titles';
  }

  @override
  String get trends => 'Trends';

  @override
  String get noTrendDataYet =>
      'Noch keine Daten — logge ein paar Tage, um deinen Trend zu sehen.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get save => 'Speichern';

  @override
  String get mlUnit => 'ml';

  @override
  String get customButton => 'Eigene Menge';

  @override
  String get addWaterDialogTitle => 'Wasser hinzufügen';

  @override
  String get addWaterHint => 'z. B. 330';

  @override
  String get editWaterDialogTitle => 'Menge bearbeiten';

  @override
  String get noWaterLoggedYet => 'Noch kein Wasser geloggt.';

  @override
  String mlAmount(int ml) {
    return '$ml ml';
  }

  @override
  String get alcoholTabTitle => 'Alkohol';

  @override
  String get getHelpTooltip => 'Hilfe holen';

  @override
  String get alcoholWarningBanner =>
      'Alkohol ist eine Droge. Er kann süchtig machen und deiner Gesundheit schaden. Tippe oben auf das Hilfe-Symbol, wenn du Unterstützung möchtest.';

  @override
  String get bacSoberLabel => '0,0 ‰ · nüchtern';

  @override
  String get bacSoberHint =>
      'Logge unten einen Drink, um mit dem Tracking zu beginnen.';

  @override
  String bacUntilZero(String bac) {
    return '$bac ‰ · bis 0,0 ‰';
  }

  @override
  String get bacDisclaimer =>
      'Nur eine Schätzung — keine medizinische Beratung. Fahre niemals unter Alkoholeinfluss.';

  @override
  String get logADrink => 'Drink loggen';

  @override
  String get historyTitle => 'Verlauf';

  @override
  String get customDrinkButton => 'Eigener Drink';

  @override
  String get customDrinkDialogTitle => 'Eigener Drink';

  @override
  String get customDrinkNameHint => 'z. B. IPA';

  @override
  String get volumeHint => 'Menge';

  @override
  String get abvSuffix => '% Vol.';

  @override
  String get abvHint => 'Alkoholstärke';

  @override
  String get defaultDrinkName => 'Drink';

  @override
  String get drinkBeer => 'Bier';

  @override
  String get drinkSmallBeer => 'Kleines Bier';

  @override
  String get drinkWine => 'Wein';

  @override
  String get drinkSparklingWine => 'Sekt';

  @override
  String get drinkShotSpirit => 'Shot / Spirituose';

  @override
  String get drinkMixedDrink => 'Mixgetränk';

  @override
  String get drinkCocktail => 'Cocktail';

  @override
  String get sugarTabTitle => 'Zucker';

  @override
  String sugarTodayGrams(String g) {
    return '$g g Zucker heute';
  }

  @override
  String sugarLimitWarning(String limit) {
    return 'Du liegst über der von der WHO empfohlenen täglichen Zucker-Obergrenze von $limit g.';
  }

  @override
  String get logASugarDrink => 'Zuckerhaltiges Getränk loggen';

  @override
  String get customSugarDrinkButton => 'Eigenes Getränk';

  @override
  String get customSugarDrinkDialogTitle => 'Eigenes Getränk';

  @override
  String get customSugarDrinkNameHint => 'z. B. Eiskaffee';

  @override
  String get sugarPer100mlSuffix => 'g/100ml';

  @override
  String get sugarPer100mlHint => 'Zuckergehalt';

  @override
  String get noSugarDrinksLoggedYet =>
      'Noch keine zuckerhaltigen Getränke geloggt.';

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
  String get drinkLemonade => 'Limonade';

  @override
  String get drinkEnergyDrink => 'Energydrink';

  @override
  String get drinkOrangeJuice => 'Orangensaft';

  @override
  String get drinkIcedTea => 'Eistee';

  @override
  String get drinkSportsDrink => 'Sportgetränk';

  @override
  String get helpSheetTitle => 'Brauchst du Unterstützung?';

  @override
  String get helpSheetIntro =>
      'Wenn dir das Trinken schwerfällt zu kontrollieren, bist du nicht allein — hier ein paar Anlaufstellen. Bei akuter Gefahr kontaktiere den lokalen Notruf.';

  @override
  String get copyLinkTooltip => 'Link kopieren';

  @override
  String get copiedToClipboard => 'In die Zwischenablage kopiert';

  @override
  String get resourceAaDetail => 'Selbsthilfegruppen weltweit';

  @override
  String get resourceSamhsaDetail =>
      'Kostenlos, vertraulich, 24/7 — 1-800-662-4357';

  @override
  String get resourceDhsDetail => 'Suchtberatung und Informationen';

  @override
  String get noDrinksLoggedYet => 'Noch keine Drinks geloggt.';

  @override
  String drinkHistorySubtitle(
    String volumeMl,
    String abvPercent,
    String relTime,
  ) {
    return '$volumeMl ml · $abvPercent% · $relTime';
  }

  @override
  String get relativeTimeJustNow => 'gerade eben';

  @override
  String relativeTimeMinutesAgo(int m) {
    return 'vor $m Min.';
  }

  @override
  String relativeTimeHoursAgo(int h) {
    return 'vor $h Std.';
  }

  @override
  String get achievementStreak3Title => '3-Tage-Streak';

  @override
  String get achievementStreak3Desc => 'Logge an 3 Tagen in Folge einen Drink.';

  @override
  String get achievementStreak7Title => '7-Tage-Streak';

  @override
  String get achievementStreak7Desc => 'Logge an 7 Tagen in Folge einen Drink.';

  @override
  String get achievementStreak30Title => '30-Tage-Streak';

  @override
  String get achievementStreak30Desc =>
      'Logge an 30 Tagen in Folge einen Drink.';

  @override
  String get achievementGoalHit5Title => 'Zielstrebig';

  @override
  String get achievementGoalHit5Desc =>
      'Erreiche 5-mal dein tägliches Trinkziel.';

  @override
  String get achievementGoalHit30Title => 'Zielmeister';

  @override
  String get achievementGoalHit30Desc =>
      'Erreiche 30-mal dein tägliches Trinkziel.';

  @override
  String get achievementDrinksLogged50Title => 'Gut hydriert';

  @override
  String get achievementDrinksLogged50Desc => 'Logge insgesamt 50 Drinks.';

  @override
  String get leaderboardTitle => 'Bestenliste';

  @override
  String get shareStreakTooltip => 'Streak teilen';

  @override
  String get addFriendTooltip => 'Freund hinzufügen';

  @override
  String get yourStreaks => 'Deine Streaks';

  @override
  String get currentStreakLabel => 'Aktueller Streak';

  @override
  String get bestStreakLabel => 'Bester Streak';

  @override
  String daysCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Tage',
      one: '$n Tag',
    );
    return '$_temp0';
  }

  @override
  String get achievementsTitle => 'Erfolge';

  @override
  String get friendsTitle => 'Freunde';

  @override
  String get friendsDescription =>
      'Vergleiche Streaks, indem du einen Code teilst — hier synct nichts automatisch, also teile erneut, um zu aktualisieren.';

  @override
  String get noFriendsImportedYet => 'Noch keine Freunde importiert.';

  @override
  String friendSubtitle(int current, int best, String importedRel) {
    return 'aktuell: $current · beste: $best · importiert $importedRel';
  }

  @override
  String get exportSheetTitle => 'Streak teilen';

  @override
  String get exportSheetDescription =>
      'Erstellt einen Textcode, den du über eine beliebige App an einen Freund schicken kannst. Nichts verlässt dieses Gerät, außer du teilst es selbst.';

  @override
  String get yourNameLabel => 'Dein Name';

  @override
  String get copyCodeTooltip => 'Code kopieren';

  @override
  String get codeCopiedSnackbar => 'Code kopiert';

  @override
  String get importSheetTitle => 'Freund hinzufügen';

  @override
  String get importSheetDescription =>
      'Füge den Code ein, den dir ein Freund geschickt hat.';

  @override
  String get pasteCodeHint => 'Code hier einfügen';

  @override
  String get invalidCodeError =>
      'Dieser Code sieht nicht richtig aus — prüfe ihn und versuche es erneut.';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get reminderIntervalTitle => 'Erinnerungsintervall';

  @override
  String get minutesUnit => 'Minuten';

  @override
  String get intervalHint => 'z. B. 45';

  @override
  String get activeHoursTitle => 'Aktive Stunden';

  @override
  String get activeHoursDescription =>
      'Erinnerungen erscheinen nur in diesem Zeitfenster, damit du nachts nicht geweckt wirst.';

  @override
  String get fromLabel => 'Von';

  @override
  String get untilLabel => 'Bis';

  @override
  String get dailyGoalTitle => 'Tägliches Trinkziel';

  @override
  String get dailyGoalDescription =>
      'Wird genutzt, um Zielerreichungs-Erfolge auf dem Bestenliste-Tab zu tracken.';

  @override
  String get dailyGoalHint => 'z. B. 2000 (500-10000)';

  @override
  String get notificationMessageTitle => 'Benachrichtigungstext';

  @override
  String get alcoholProfileTitle => 'Alkoholprofil';

  @override
  String get alcoholProfileDescription =>
      'Wird nur genutzt, um die Blutalkohol-Schätzung im Alkohol-Tab zu personalisieren — verlässt niemals dein Gerät.';

  @override
  String get maleLabel => 'Männlich';

  @override
  String get femaleLabel => 'Weiblich';

  @override
  String get otherLabel => 'Divers';

  @override
  String get ageLabel => 'Alter';

  @override
  String get yearsUnit => 'Jahre';

  @override
  String get weightLabel => 'Gewicht';

  @override
  String get kgUnit => 'kg';

  @override
  String get appearanceTitle => 'Darstellung';

  @override
  String get useDynamicColorTitle => 'Geräte-Akzentfarbe verwenden';

  @override
  String get useDynamicColorDescription =>
      'Themt die App mit der Akzentfarbe deines Hintergrundbilds (Android 12+) statt dem eingebauten Türkis.';

  @override
  String get fontFamilyTitle => 'Schriftart';

  @override
  String get fontFamilyDefault => 'Standard';

  @override
  String get fontFamilySerif => 'Serif';

  @override
  String get fontFamilyCondensed => 'Schmal';

  @override
  String get fontFamilyMonospace => 'Monospace';

  @override
  String get settingsSaved => 'Einstellungen gespeichert';

  @override
  String get errorEnterInterval =>
      'Gib ein Erinnerungsintervall in Minuten ein';

  @override
  String get errorActiveWindowOrder =>
      'Die Startzeit muss vor der Endzeit liegen';

  @override
  String errorDailyGoalRange(int min, int max) {
    return 'Gib ein tägliches Trinkziel zwischen $min und $max ml ein';
  }

  @override
  String get errorAgeWeight => 'Gib ein gültiges Alter und Gewicht ein';

  @override
  String get notificationTitle => 'Bleib hydriert 💧';

  @override
  String get notificationDefaultMessage => 'Zeit, etwas Wasser zu trinken 💧';

  @override
  String get notificationActionLabel => 'Getrunken 💧';

  @override
  String get notificationChannelDescription => 'Erinnerungen zum Trinken';
}
