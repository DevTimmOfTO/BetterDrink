// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get navHydration => 'Drinken';

  @override
  String get navSugar => 'Suiker';

  @override
  String get navAlcohol => 'Alcohol';

  @override
  String get navLeaderboard => 'Ranglijst';

  @override
  String get navSettings => 'Instellingen';

  @override
  String get homeAppBarTitle => 'BetterDrink';

  @override
  String get homeReminderDue => 'tijd om te drinken';

  @override
  String get homeUntilNextReminder => 'tot de volgende herinnering';

  @override
  String get homeNow => 'Nu';

  @override
  String homeTodayMl(int ml) {
    return '$ml ml vandaag';
  }

  @override
  String homeTodayPouredNote(int ml) {
    return 'van $ml ml aan drankjes';
  }

  @override
  String homeAchievementUnlocked(String titles) {
    return 'Prestatie ontgrendeld: $titles';
  }

  @override
  String get trends => 'Trends';

  @override
  String get noTrendDataYet =>
      'Nog geen gegevens — houd een paar dagen bij om je trend te zien.';

  @override
  String get cancel => 'Annuleren';

  @override
  String get add => 'Toevoegen';

  @override
  String get save => 'Opslaan';

  @override
  String get mlUnit => 'ml';

  @override
  String get customButton => 'Aangepast';

  @override
  String addBeverageDialogTitle(String beverage) {
    return '$beverage toevoegen';
  }

  @override
  String get addWaterHint => 'bijv. 330';

  @override
  String get editWaterDialogTitle => 'Hoeveelheid bewerken';

  @override
  String get noWaterLoggedYet => 'Nog geen drankjes geregistreerd.';

  @override
  String mlAmount(int ml) {
    return '$ml ml';
  }

  @override
  String get beverageWater => 'Water';

  @override
  String get beverageCoffee => 'Koffie';

  @override
  String get beverageTea => 'Thee';

  @override
  String beverageCreditedNote(int ml) {
    return '$ml ml meegeteld';
  }

  @override
  String beverageFactorNoteCoffee(int percent) {
    return 'Koffie telt voor $percent% als vocht — cafeïne werkt licht vochtafdrijvend.';
  }

  @override
  String beverageFactorNoteTea(int percent) {
    return 'Zwarte en groene thee tellen voor $percent% als vocht — registreer kruiden- of vruchtenthee als water.';
  }

  @override
  String beverageHistorySubtitle(String beverage, String relTime) {
    return '$beverage · $relTime';
  }

  @override
  String get servingEspresso => 'Espresso';

  @override
  String get servingCup => 'Kopje';

  @override
  String get servingMug => 'Mok';

  @override
  String get servingPot => 'Pot';

  @override
  String get servingGlass => 'Glas';

  @override
  String get servingBottle => 'Fles';

  @override
  String get servingLargeBottle => 'Grote fles';

  @override
  String get alcoholTabTitle => 'Alcohol';

  @override
  String get getHelpTooltip => 'Hulp zoeken';

  @override
  String get alcoholWarningBanner =>
      'Alcohol is een drug. Het kan verslavend zijn en schadelijk voor je gezondheid. Tik bovenaan op het hulppictogram als je ondersteuning wilt.';

  @override
  String get bacSoberLabel => '0,0‰ · nuchter';

  @override
  String get bacSoberHint =>
      'Registreer hieronder een drankje om te beginnen met bijhouden.';

  @override
  String bacUntilZero(String bac) {
    return '$bac‰ · tot 0,0‰';
  }

  @override
  String get bacDisclaimer =>
      'Alleen een schatting — geen medisch advies. Rijd nooit onder invloed.';

  @override
  String get logADrink => 'Drankje registreren';

  @override
  String get historyTitle => 'Geschiedenis';

  @override
  String get customDrinkButton => 'Eigen drankje';

  @override
  String get customDrinkDialogTitle => 'Eigen drankje';

  @override
  String get customDrinkNameHint => 'bijv. IPA';

  @override
  String get volumeHint => 'Hoeveelheid';

  @override
  String get abvSuffix => '% vol.';

  @override
  String get abvHint => 'Alcoholpercentage';

  @override
  String get defaultDrinkName => 'Drankje';

  @override
  String get drinkBeer => 'Bier';

  @override
  String get drinkSmallBeer => 'Klein biertje';

  @override
  String get drinkWine => 'Wijn';

  @override
  String get drinkSparklingWine => 'Mousserende wijn';

  @override
  String get drinkShotSpirit => 'Shot / sterkedrank';

  @override
  String get drinkMixedDrink => 'Longdrink';

  @override
  String get drinkCocktail => 'Cocktail';

  @override
  String get sugarTabTitle => 'Suiker';

  @override
  String sugarTodayGrams(String g) {
    return '$g g suiker vandaag';
  }

  @override
  String sugarLimitWarning(String limit) {
    return 'Je zit boven de door de WHO aanbevolen dagelijkse suikerlimiet van $limit g.';
  }

  @override
  String get logASugarDrink => 'Suikerhoudend drankje registreren';

  @override
  String get customSugarDrinkButton => 'Eigen drankje';

  @override
  String get customSugarDrinkDialogTitle => 'Eigen drankje';

  @override
  String get customSugarDrinkNameHint => 'bijv. IJskoffie';

  @override
  String get sugarPer100mlSuffix => 'g/100 ml';

  @override
  String get sugarPer100mlHint => 'Suikergehalte';

  @override
  String get noSugarDrinksLoggedYet =>
      'Nog geen suikerhoudende drankjes geregistreerd.';

  @override
  String sugarHistorySubtitle(
    String volumeMl,
    String sugarPer100ml,
    String relTime,
  ) {
    return '$volumeMl ml · $sugarPer100ml g/100 ml · $relTime';
  }

  @override
  String get drinkCola => 'Cola';

  @override
  String get drinkLemonade => 'Limonade';

  @override
  String get drinkEnergyDrink => 'Energiedrank';

  @override
  String get drinkOrangeJuice => 'Sinaasappelsap';

  @override
  String get drinkIcedTea => 'IJsthee';

  @override
  String get drinkSportsDrink => 'Sportdrank';

  @override
  String get helpSheetTitle => 'Ondersteuning nodig?';

  @override
  String get helpSheetIntro =>
      'Als je moeite hebt om je drinken onder controle te houden, ben je niet de enige — hier zijn een paar plekken om te beginnen. Ben je in direct gevaar? Neem dan contact op met de lokale hulpdiensten.';

  @override
  String get copyLinkTooltip => 'Link kopiëren';

  @override
  String get copiedToClipboard => 'Gekopieerd naar klembord';

  @override
  String get resourceAaDetail => 'Zelfhulpbijeenkomsten wereldwijd';

  @override
  String get resourceSamhsaDetail =>
      'Gratis, vertrouwelijk, 24/7 — 1-800-662-4357';

  @override
  String get resourceDhsDetail => 'Verslavingsadvies en informatie';

  @override
  String get noDrinksLoggedYet => 'Nog geen drankjes geregistreerd.';

  @override
  String drinkHistorySubtitle(
    String volumeMl,
    String abvPercent,
    String relTime,
  ) {
    return '$volumeMl ml · $abvPercent% · $relTime';
  }

  @override
  String get relativeTimeJustNow => 'zojuist';

  @override
  String relativeTimeMinutesAgo(int m) {
    return '$m min. geleden';
  }

  @override
  String relativeTimeHoursAgo(int h) {
    return '$h uur geleden';
  }

  @override
  String get achievementStreak3Title => 'Reeks van 3 dagen';

  @override
  String get achievementStreak3Desc => 'Registreer 3 dagen op rij een drankje.';

  @override
  String get achievementStreak7Title => 'Reeks van 7 dagen';

  @override
  String get achievementStreak7Desc => 'Registreer 7 dagen op rij een drankje.';

  @override
  String get achievementStreak30Title => 'Reeks van 30 dagen';

  @override
  String get achievementStreak30Desc =>
      'Registreer 30 dagen op rij een drankje.';

  @override
  String get achievementGoalHit5Title => 'Doelgericht';

  @override
  String get achievementGoalHit5Desc => 'Haal 5 keer je dagelijkse drinkdoel.';

  @override
  String get achievementGoalHit30Title => 'Topscorer';

  @override
  String get achievementGoalHit30Desc =>
      'Haal 30 keer je dagelijkse drinkdoel.';

  @override
  String get achievementDrinksLogged50Title => 'Goed gehydrateerd';

  @override
  String get achievementDrinksLogged50Desc =>
      'Registreer in totaal 50 drankjes.';

  @override
  String get leaderboardTitle => 'Ranglijst';

  @override
  String get shareStreakTooltip => 'Deel je reeks';

  @override
  String get addFriendTooltip => 'Vriend toevoegen';

  @override
  String get yourStreaks => 'Jouw reeksen';

  @override
  String get currentStreakLabel => 'Huidige reeks';

  @override
  String get bestStreakLabel => 'Beste reeks';

  @override
  String daysCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n dagen',
      one: '$n dag',
    );
    return '$_temp0';
  }

  @override
  String get achievementsTitle => 'Prestaties';

  @override
  String get friendsTitle => 'Vrienden';

  @override
  String get friendsDescription =>
      'Vergelijk reeksen door een code te delen — hier wordt niets automatisch gesynchroniseerd, dus deel opnieuw om bij te werken.';

  @override
  String get noFriendsImportedYet => 'Nog geen vrienden geïmporteerd.';

  @override
  String friendSubtitle(int current, int best, String importedRel) {
    return 'huidig: $current · beste: $best · geïmporteerd $importedRel';
  }

  @override
  String get exportSheetTitle => 'Deel je reeks';

  @override
  String get exportSheetDescription =>
      'Maakt een tekstcode die je via elke app naar een vriend kunt sturen. Er verlaat niets dit apparaat, tenzij je het zelf deelt.';

  @override
  String get yourNameLabel => 'Je naam';

  @override
  String get copyCodeTooltip => 'Code kopiëren';

  @override
  String get codeCopiedSnackbar => 'Code gekopieerd';

  @override
  String get importSheetTitle => 'Vriend toevoegen';

  @override
  String get importSheetDescription =>
      'Plak de code die een vriend met je heeft gedeeld.';

  @override
  String get pasteCodeHint => 'Plak de code hier';

  @override
  String get invalidCodeError =>
      'Die code lijkt niet te kloppen — controleer hem en probeer het opnieuw.';

  @override
  String get settingsTitle => 'Instellingen';

  @override
  String get reminderIntervalTitle => 'Herinneringsinterval';

  @override
  String get reminderIntervalChangeNote => 'Dit verandert binnenkort.';

  @override
  String get minutesUnit => 'minuten';

  @override
  String get intervalHint => 'bijv. 45';

  @override
  String get activeHoursTitle => 'Actieve uren';

  @override
  String get activeHoursDescription =>
      'Herinneringen komen alleen binnen dit tijdvenster, zodat je \'s nachts niet wakker wordt gemaakt.';

  @override
  String get fromLabel => 'Van';

  @override
  String get untilLabel => 'Tot';

  @override
  String get dailyGoalTitle => 'Dagelijks drinkdoel';

  @override
  String get dailyGoalDescription =>
      'Wordt gebruikt om doelprestaties bij te houden op het tabblad Ranglijst.';

  @override
  String get dailyGoalHint => 'bijv. 2000 (500-10000)';

  @override
  String get notificationMessageTitle => 'Meldingstekst';

  @override
  String get alcoholProfileTitle => 'Alcoholprofiel';

  @override
  String get alcoholProfileDescription =>
      'Wordt alleen gebruikt om de schatting van je bloedalcoholgehalte op het tabblad Alcohol te personaliseren — het verlaat nooit je apparaat.';

  @override
  String get maleLabel => 'Man';

  @override
  String get femaleLabel => 'Vrouw';

  @override
  String get otherLabel => 'Anders';

  @override
  String get sexLabel => 'Geslacht';

  @override
  String get ageLabel => 'Leeftijd';

  @override
  String get yearsUnit => 'jaar';

  @override
  String get weightLabel => 'Gewicht';

  @override
  String get kgUnit => 'kg';

  @override
  String get appearanceTitle => 'Weergave';

  @override
  String get useDynamicColorTitle => 'Accentkleur van apparaat gebruiken';

  @override
  String get useDynamicColorDescription =>
      'Geef de app de accentkleur van je achtergrond (Android 12+) in plaats van het ingebouwde blauwgroen.';

  @override
  String get fontFamilyTitle => 'Lettertype';

  @override
  String get fontFamilyDefault => 'Standaard';

  @override
  String get fontFamilySerif => 'Schreef';

  @override
  String get fontFamilyCondensed => 'Smal';

  @override
  String get fontFamilyMonospace => 'Monospace';

  @override
  String get healthConnectTitle => 'Health Connect';

  @override
  String get healthConnectDescription =>
      'Geregistreerde drankjes automatisch als hydratatiegegevens naar Google Health Connect schrijven.';

  @override
  String get healthConnectSyncTitle =>
      'Drankjes synchroniseren met Health Connect';

  @override
  String get healthConnectNeedsInstallMessage =>
      'Health Connect is niet geïnstalleerd of moet worden bijgewerkt. Installeer of update het en probeer het opnieuw.';

  @override
  String get healthConnectPermissionDeniedMessage =>
      'Toestemming voor Health Connect is geweigerd.';

  @override
  String get settingsSaved => 'Instellingen opgeslagen';

  @override
  String get errorEnterInterval =>
      'Voer een herinneringsinterval in minuten in';

  @override
  String get errorActiveWindowOrder =>
      'De starttijd moet vóór de eindtijd liggen';

  @override
  String errorDailyGoalRange(int min, int max) {
    return 'Voer een dagelijks drinkdoel in tussen $min en $max ml';
  }

  @override
  String get errorAgeWeight =>
      'Voer een geldige leeftijd en een geldig gewicht in';

  @override
  String get importFromHealthConnect => 'Importeren uit Health Connect';

  @override
  String get importFromHealthConnectDescription =>
      'Laad je leeftijd, geslacht en gewicht uit Google Health Connect om de schatting van je bloedalcoholgehalte te personaliseren.';

  @override
  String get healthConnectProfileImportSuccess =>
      'Profiel geïmporteerd uit Health Connect';

  @override
  String get healthConnectProfileImportFailed =>
      'Profiel importeren uit Health Connect is mislukt';

  @override
  String get healthConnectProfileNoData =>
      'Geen profielgegevens beschikbaar in Health Connect';

  @override
  String get healthConnectImportDialogTitle => 'Kies wat je wilt importeren';

  @override
  String get import => 'Importeren';

  @override
  String get notificationTitle => 'Blijf gehydrateerd 💧';

  @override
  String get notificationDefaultMessage => 'Tijd om wat water te drinken 💧';

  @override
  String get notificationActionLabel => 'Gedronken 💧';

  @override
  String get notificationChannelDescription =>
      'Herinneringen om water te drinken';
}
