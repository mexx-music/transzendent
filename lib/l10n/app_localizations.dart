import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
  ];

  /// App-Name
  ///
  /// In de, this message translates to:
  /// **'Transzendent'**
  String get appTitle;

  /// App-Tagline unter dem Titel
  ///
  /// In de, this message translates to:
  /// **'Positive Suggestionen · Hypnose · Innere Ruhe'**
  String get appTagline;

  /// Abschnittsüberschrift – Zuletzt gehört
  ///
  /// In de, this message translates to:
  /// **'Zuletzt gehört'**
  String get sectionRecentlyPlayed;

  /// Abschnittsüberschrift – Favoriten
  ///
  /// In de, this message translates to:
  /// **'Favoriten'**
  String get sectionFavorites;

  /// Abschnittsüberschrift – Kategorien
  ///
  /// In de, this message translates to:
  /// **'Kategorien'**
  String get sectionCategories;

  /// Link zum Anzeigen aller Einträge
  ///
  /// In de, this message translates to:
  /// **'Alle anzeigen'**
  String get showAll;

  /// Mini-Player: kein Titel aktiv
  ///
  /// In de, this message translates to:
  /// **'Kein Titel aktiv'**
  String get playerNoTitle;

  /// Mini-Player: Aufforderung zur Auswahl
  ///
  /// In de, this message translates to:
  /// **'Wähle eine Session aus'**
  String get playerChooseSession;

  /// Playerstatus: läuft
  ///
  /// In de, this message translates to:
  /// **'Wird abgespielt …'**
  String get playerPlaying;

  /// Playerstatus: pausiert
  ///
  /// In de, this message translates to:
  /// **'Pausiert'**
  String get playerPaused;

  /// Playerstatus: gestoppt
  ///
  /// In de, this message translates to:
  /// **'Gestoppt'**
  String get playerStopped;

  /// Tooltip/Button: Stoppen
  ///
  /// In de, this message translates to:
  /// **'Stoppen'**
  String get playerStop;

  /// Tooltip: Pause
  ///
  /// In de, this message translates to:
  /// **'Pause'**
  String get playerPause;

  /// Tooltip/Button: Fortsetzen
  ///
  /// In de, this message translates to:
  /// **'Fortsetzen'**
  String get playerResume;

  /// Button: Session starten
  ///
  /// In de, this message translates to:
  /// **'Session starten'**
  String get playerStart;

  /// Leer-Zustand SessionListScreen
  ///
  /// In de, this message translates to:
  /// **'Noch keine Sessions in dieser Kategorie.'**
  String get noSessionsInCategory;

  /// Tooltip Favoriten-Button: hinzufügen
  ///
  /// In de, this message translates to:
  /// **'Zu Favoriten hinzufügen'**
  String get favoriteAdd;

  /// Tooltip Favoriten-Button: entfernen
  ///
  /// In de, this message translates to:
  /// **'Aus Favoriten entfernen'**
  String get favoriteRemove;

  /// Dauer in Minuten
  ///
  /// In de, this message translates to:
  /// **'{minutes} Minuten'**
  String durationMinutes(int minutes);

  /// Hinweis wenn kein Audio vorhanden
  ///
  /// In de, this message translates to:
  /// **'Noch keine Audiodatei hinterlegt.'**
  String get noAudioFile;

  /// Premium-Hinweis auf DetailScreen
  ///
  /// In de, this message translates to:
  /// **'Diese Session ist Teil des Premium-Bereichs.'**
  String get premiumHint;

  /// Premium-Badge-Label
  ///
  /// In de, this message translates to:
  /// **'Premium'**
  String get premiumBadge;

  /// Titel des Bibliothek-Screens
  ///
  /// In de, this message translates to:
  /// **'Bibliothek'**
  String get libraryTitle;

  /// Leer-Zustand Bibliothek: Überschrift
  ///
  /// In de, this message translates to:
  /// **'Noch keine Einträge'**
  String get libraryEmpty;

  /// Leer-Zustand Bibliothek: Hinweistext
  ///
  /// In de, this message translates to:
  /// **'Starte eine Session oder markiere\nSessions als Favoriten.'**
  String get libraryEmptyHint;

  /// Abschnittsüberschrift Hintergrundklang-Picker
  ///
  /// In de, this message translates to:
  /// **'Hintergrund'**
  String get backgroundSoundTitle;

  /// Beschreibung wenn Stille ausgewählt
  ///
  /// In de, this message translates to:
  /// **'Keine Hintergrundmusik aktiv.'**
  String get backgroundSoundNone;

  /// Abschnittsüberschrift Sleep-Timer-Picker
  ///
  /// In de, this message translates to:
  /// **'Timer'**
  String get timerTitle;

  /// Timer-Chip-Label für keine Timer-Option
  ///
  /// In de, this message translates to:
  /// **'Ohne Timer'**
  String get timerNoTimer;

  /// Timer-Hinweis: kein automatischer Stopp
  ///
  /// In de, this message translates to:
  /// **'Die Session läuft ohne automatischen Stopp.'**
  String get timerUnlimited;

  /// Timer-Hinweis mit Minutenangabe
  ///
  /// In de, this message translates to:
  /// **'Stoppt automatisch nach {minutes} Minuten.'**
  String timerAutoStop(int minutes);

  /// Abschnittsüberschrift Suggestion-Karte
  ///
  /// In de, this message translates to:
  /// **'Suggestion'**
  String get suggestionTitle;

  /// Button: Suggestion-Text ansehen
  ///
  /// In de, this message translates to:
  /// **'Text ansehen'**
  String get suggestionViewText;

  /// Abkürzung Minuten im Dauer-Badge
  ///
  /// In de, this message translates to:
  /// **'min'**
  String get durationBadgeMin;

  /// AppBar-Titel ScriptPreviewScreen
  ///
  /// In de, this message translates to:
  /// **'Suggestions-Text'**
  String get scriptPreviewTitle;

  /// Abschnittsüberschrift: Themen
  ///
  /// In de, this message translates to:
  /// **'Themen dieser Session'**
  String get scriptPreviewTopics;

  /// Abschnittsüberschrift: Gesprochener Text
  ///
  /// In de, this message translates to:
  /// **'Gesprochener Text'**
  String get scriptPreviewSpokenText;

  /// Titel des Einstellungen-Screens
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get settingsTitle;

  /// Einstellungs-Abschnitt: Sprache
  ///
  /// In de, this message translates to:
  /// **'Sprache'**
  String get settingsLanguage;

  /// Sprachoption: Deutsch
  ///
  /// In de, this message translates to:
  /// **'Deutsch'**
  String get settingsLanguageDe;

  /// Sprachoption: Englisch
  ///
  /// In de, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;
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
      <String>['de', 'en'].contains(locale.languageCode);

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
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
