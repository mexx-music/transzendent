// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Transzendent';

  @override
  String get appTagline => 'Positive Suggestions · Hypnosis · Inner Peace';

  @override
  String get sectionRecentlyPlayed => 'Recently Played';

  @override
  String get sectionFavorites => 'Favorites';

  @override
  String get sectionCategories => 'Categories';

  @override
  String get showAll => 'Show All';

  @override
  String get playerNoTitle => 'No session active';

  @override
  String get playerChooseSession => 'Choose a session';

  @override
  String get playerPlaying => 'Playing …';

  @override
  String get playerPaused => 'Paused';

  @override
  String get playerStopped => 'Stopped';

  @override
  String get playerStop => 'Stop';

  @override
  String get playerPause => 'Pause';

  @override
  String get playerResume => 'Resume';

  @override
  String get playerStart => 'Start session';

  @override
  String get noSessionsInCategory => 'No sessions in this category yet.';

  @override
  String get favoriteAdd => 'Add to favorites';

  @override
  String get favoriteRemove => 'Remove from favorites';

  @override
  String durationMinutes(int minutes) {
    return '$minutes minutes';
  }

  @override
  String get noAudioFile => 'No audio file available yet.';

  @override
  String get premiumHint => 'This session is part of the Premium area.';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get libraryTitle => 'Library';

  @override
  String get libraryEmpty => 'Nothing here yet';

  @override
  String get libraryEmptyHint =>
      'Start a session or mark\nsessions as favorites.';

  @override
  String get backgroundSoundTitle => 'Background';

  @override
  String get backgroundSoundNone => 'No background music active.';

  @override
  String get timerTitle => 'Timer';

  @override
  String get timerNoTimer => 'No timer';

  @override
  String get timerUnlimited => 'The session runs without automatic stop.';

  @override
  String timerAutoStop(int minutes) {
    return 'Stops automatically after $minutes minutes.';
  }

  @override
  String get suggestionTitle => 'Suggestion';

  @override
  String get suggestionViewText => 'View text';

  @override
  String get durationBadgeMin => 'min';

  @override
  String get scriptPreviewTitle => 'Suggestion Text';

  @override
  String get scriptPreviewTopics => 'Topics of this session';

  @override
  String get scriptPreviewSpokenText => 'Spoken Text';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageDe => 'Deutsch';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get volumeVoice => 'Voice';

  @override
  String get volumeBackground => 'Background';

  @override
  String backgroundCountActive(int count) {
    return '$count sounds active';
  }
}
