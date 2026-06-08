// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Transzendent';

  @override
  String get appTagline => 'Positive Suggestionen · Hypnose · Innere Ruhe';

  @override
  String get sectionRecentlyPlayed => 'Zuletzt gehört';

  @override
  String get sectionFavorites => 'Favoriten';

  @override
  String get sectionCategories => 'Kategorien';

  @override
  String get showAll => 'Alle anzeigen';

  @override
  String get playerNoTitle => 'Kein Titel aktiv';

  @override
  String get playerChooseSession => 'Wähle eine Session aus';

  @override
  String get playerPlaying => 'Wird abgespielt …';

  @override
  String get playerPaused => 'Pausiert';

  @override
  String get playerStopped => 'Gestoppt';

  @override
  String get playerStop => 'Stoppen';

  @override
  String get playerPause => 'Pause';

  @override
  String get playerResume => 'Fortsetzen';

  @override
  String get playerStart => 'Session starten';

  @override
  String get noSessionsInCategory => 'Noch keine Sessions in dieser Kategorie.';

  @override
  String get favoriteAdd => 'Zu Favoriten hinzufügen';

  @override
  String get favoriteRemove => 'Aus Favoriten entfernen';

  @override
  String durationMinutes(int minutes) {
    return '$minutes Minuten';
  }

  @override
  String get noAudioFile => 'Noch keine Audiodatei hinterlegt.';

  @override
  String get premiumHint => 'Diese Session ist Teil des Premium-Bereichs.';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get libraryTitle => 'Bibliothek';

  @override
  String get libraryEmpty => 'Noch keine Einträge';

  @override
  String get libraryEmptyHint =>
      'Starte eine Session oder markiere\nSessions als Favoriten.';

  @override
  String get backgroundSoundTitle => 'Hintergrund';

  @override
  String get backgroundSoundNone => 'Keine Hintergrundmusik aktiv.';

  @override
  String get timerTitle => 'Timer';

  @override
  String get timerNoTimer => 'Ohne Timer';

  @override
  String get timerUnlimited => 'Die Session läuft ohne automatischen Stopp.';

  @override
  String timerAutoStop(int minutes) {
    return 'Stoppt automatisch nach $minutes Minuten.';
  }

  @override
  String get suggestionTitle => 'Suggestion';

  @override
  String get suggestionViewText => 'Text ansehen';

  @override
  String get durationBadgeMin => 'min';

  @override
  String get scriptPreviewTitle => 'Suggestions-Text';

  @override
  String get scriptPreviewTopics => 'Themen dieser Session';

  @override
  String get scriptPreviewSpokenText => 'Gesprochener Text';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsLanguageDe => 'Deutsch';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get volumeVoice => 'Stimme';

  @override
  String get volumeBackground => 'Hintergrund';
}
