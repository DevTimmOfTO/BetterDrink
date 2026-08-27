// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get navAlcoholFree => 'Sans alcool';

  @override
  String get navAlcohol => 'Alcool';

  @override
  String get navLeaderboard => 'Classement';

  @override
  String get navSettings => 'Réglages';

  @override
  String get homeAppBarTitle => 'BetterDrink';

  @override
  String get homeReminderDue => 'rappel dû';

  @override
  String get homeUntilNextReminder => 'avant le prochain rappel';

  @override
  String get homeNow => 'Maintenant';

  @override
  String homeTodayMl(int ml) {
    return '$ml ml aujourd\'hui';
  }

  @override
  String homeAchievementUnlocked(String titles) {
    return 'Succès débloqué : $titles';
  }

  @override
  String get trends => 'Tendances';

  @override
  String get noTrendDataYet =>
      'Pas encore de données — enregistrez quelques jours pour voir votre tendance.';

  @override
  String get cancel => 'Annuler';

  @override
  String get add => 'Ajouter';

  @override
  String get save => 'Enregistrer';

  @override
  String get mlUnit => 'ml';

  @override
  String get customButton => 'Personnalisé';

  @override
  String get addWaterDialogTitle => 'Ajouter de l\'eau';

  @override
  String get addWaterHint => 'ex. 330';

  @override
  String mlAmount(int ml) {
    return '$ml ml';
  }

  @override
  String get alcoholTabTitle => 'Alcool';

  @override
  String get getHelpTooltip => 'Obtenir de l\'aide';

  @override
  String get alcoholWarningBanner =>
      'L\'alcool est une drogue. Il peut créer une dépendance et nuire à votre santé. Appuyez sur l\'icône d\'aide ci-dessus si vous souhaitez du soutien.';

  @override
  String get bacSoberLabel => '0,0 ‰ · sobre';

  @override
  String get bacSoberHint =>
      'Enregistrez un verre ci-dessous pour commencer le suivi.';

  @override
  String bacUntilZero(String bac) {
    return '$bac ‰ · jusqu\'à 0,0 ‰';
  }

  @override
  String get bacDisclaimer =>
      'Estimation uniquement — ce n\'est pas un avis médical. Ne conduisez jamais après avoir bu.';

  @override
  String get logADrink => 'Enregistrer un verre';

  @override
  String get historyTitle => 'Historique';

  @override
  String get customDrinkButton => 'Boisson personnalisée';

  @override
  String get customDrinkDialogTitle => 'Boisson personnalisée';

  @override
  String get customDrinkNameHint => 'ex. IPA';

  @override
  String get volumeHint => 'Volume';

  @override
  String get abvSuffix => '% vol.';

  @override
  String get abvHint => 'Teneur en alcool';

  @override
  String get defaultDrinkName => 'Boisson';

  @override
  String get drinkBeer => 'Bière';

  @override
  String get drinkSmallBeer => 'Petite bière';

  @override
  String get drinkWine => 'Vin';

  @override
  String get drinkSparklingWine => 'Vin mousseux';

  @override
  String get drinkShotSpirit => 'Shot / spiritueux';

  @override
  String get drinkMixedDrink => 'Cocktail long';

  @override
  String get drinkCocktail => 'Cocktail';

  @override
  String get helpSheetTitle => 'Besoin de soutien ?';

  @override
  String get helpSheetIntro =>
      'Si contrôler votre consommation d\'alcool est difficile, vous n\'êtes pas seul·e — voici quelques pistes. En cas de danger immédiat, contactez les services d\'urgence locaux.';

  @override
  String get copyLinkTooltip => 'Copier le lien';

  @override
  String get copiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get resourceAaDetail => 'Réunions d\'entraide dans le monde entier';

  @override
  String get resourceSamhsaDetail =>
      'Gratuit, confidentiel, 24h/24 — 1-800-662-4357';

  @override
  String get resourceDhsDetail => 'Conseil et informations sur les addictions';

  @override
  String get noDrinksLoggedYet => 'Aucune boisson enregistrée pour l\'instant.';

  @override
  String drinkHistorySubtitle(
    String volumeMl,
    String abvPercent,
    String relTime,
  ) {
    return '$volumeMl ml · $abvPercent% · $relTime';
  }

  @override
  String get relativeTimeJustNow => 'à l\'instant';

  @override
  String relativeTimeMinutesAgo(int m) {
    return 'il y a $m min';
  }

  @override
  String relativeTimeHoursAgo(int h) {
    return 'il y a $h h';
  }

  @override
  String get achievementStreak3Title => 'Série de 3 jours';

  @override
  String get achievementStreak3Desc =>
      'Enregistrez une boisson 3 jours de suite.';

  @override
  String get achievementStreak7Title => 'Série de 7 jours';

  @override
  String get achievementStreak7Desc =>
      'Enregistrez une boisson 7 jours de suite.';

  @override
  String get achievementStreak30Title => 'Série de 30 jours';

  @override
  String get achievementStreak30Desc =>
      'Enregistrez une boisson 30 jours de suite.';

  @override
  String get achievementGoalHit5Title => 'Objectif atteint';

  @override
  String get achievementGoalHit5Desc =>
      'Atteignez votre objectif d\'hydratation quotidien 5 fois.';

  @override
  String get achievementGoalHit30Title => 'Maître de l\'objectif';

  @override
  String get achievementGoalHit30Desc =>
      'Atteignez votre objectif d\'hydratation quotidien 30 fois.';

  @override
  String get achievementDrinksLogged50Title => 'Bien hydraté·e';

  @override
  String get achievementDrinksLogged50Desc =>
      'Enregistrez 50 boissons au total.';

  @override
  String get leaderboardTitle => 'Classement';

  @override
  String get shareStreakTooltip => 'Partager votre série';

  @override
  String get addFriendTooltip => 'Ajouter un ami';

  @override
  String get yourStreaks => 'Vos séries';

  @override
  String get currentStreakLabel => 'Série actuelle';

  @override
  String get bestStreakLabel => 'Meilleure série';

  @override
  String daysCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n jours',
      one: '$n jour',
    );
    return '$_temp0';
  }

  @override
  String get achievementsTitle => 'Succès';

  @override
  String get friendsTitle => 'Amis';

  @override
  String get friendsDescription =>
      'Comparez vos séries en partageant un code — rien ne se synchronise automatiquement ici, repartagez pour actualiser.';

  @override
  String get noFriendsImportedYet => 'Aucun ami importé pour l\'instant.';

  @override
  String friendSubtitle(int current, int best, String importedRel) {
    return 'actuelle : $current · meilleure : $best · importé $importedRel';
  }

  @override
  String get exportSheetTitle => 'Partager votre série';

  @override
  String get exportSheetDescription =>
      'Génère un code texte que vous pouvez envoyer à un ami via n\'importe quelle app. Rien ne quitte cet appareil sauf si vous le partagez vous-même.';

  @override
  String get yourNameLabel => 'Votre nom';

  @override
  String get copyCodeTooltip => 'Copier le code';

  @override
  String get codeCopiedSnackbar => 'Code copié';

  @override
  String get importSheetTitle => 'Ajouter un ami';

  @override
  String get importSheetDescription =>
      'Collez le code qu\'un ami vous a partagé.';

  @override
  String get pasteCodeHint => 'Collez le code ici';

  @override
  String get invalidCodeError =>
      'Ce code ne semble pas correct — vérifiez-le et réessayez.';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get reminderIntervalTitle => 'Intervalle de rappel';

  @override
  String get minutesUnit => 'minutes';

  @override
  String get intervalHint => 'ex. 45';

  @override
  String get activeHoursTitle => 'Heures actives';

  @override
  String get activeHoursDescription =>
      'Les rappels ne se déclenchent que pendant cette plage horaire, pour ne pas vous réveiller la nuit.';

  @override
  String get fromLabel => 'De';

  @override
  String get untilLabel => 'À';

  @override
  String get dailyGoalTitle => 'Objectif d\'hydratation quotidien';

  @override
  String get dailyGoalDescription =>
      'Utilisé pour suivre les succès liés à l\'objectif dans l\'onglet Classement.';

  @override
  String get dailyGoalHint => 'ex. 2000 (500-10000)';

  @override
  String get notificationMessageTitle => 'Message de notification';

  @override
  String get alcoholProfileTitle => 'Profil alcool';

  @override
  String get alcoholProfileDescription =>
      'Utilisé uniquement pour personnaliser l\'estimation d\'alcoolémie dans l\'onglet Alcool — ne quitte jamais votre appareil.';

  @override
  String get maleLabel => 'Homme';

  @override
  String get femaleLabel => 'Femme';

  @override
  String get otherLabel => 'Autre';

  @override
  String get ageLabel => 'Âge';

  @override
  String get yearsUnit => 'ans';

  @override
  String get weightLabel => 'Poids';

  @override
  String get kgUnit => 'kg';

  @override
  String get settingsSaved => 'Réglages enregistrés';

  @override
  String get errorEnterInterval => 'Entrez un intervalle de rappel en minutes';

  @override
  String get errorActiveWindowOrder =>
      'L\'heure de début doit précéder l\'heure de fin';

  @override
  String errorDailyGoalRange(int min, int max) {
    return 'Entrez un objectif d\'hydratation quotidien entre $min et $max ml';
  }

  @override
  String get errorAgeWeight => 'Entrez un âge et un poids valides';

  @override
  String get notificationTitle => 'Restez hydraté·e 💧';

  @override
  String get notificationActionLabel => 'Bu 💧';

  @override
  String get notificationChannelDescription => 'Rappels pour boire de l\'eau';
}
