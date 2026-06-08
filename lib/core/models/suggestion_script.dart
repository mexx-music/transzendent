/// Modell für einen Suggestions-/Hypnose-Text zu einer Session.
class SuggestionScript {
  final String id;

  /// Verknüpfung zur [HypnosisSession.id]
  final String sessionId;

  /// Kurzer Anzeigetitel des Scripts
  final String title;

  /// Einleitungstext – kurze Beschreibung, was den Hörer erwartet
  final String introText;

  /// Schlüsselwörter / Themen als Chips darstellbar
  final List<String> suggestionWords;

  /// Vollständiger gesprochener Text – für [ScriptPreviewScreen]
  final String spokenScript;

  /// Pflichthinweis – wird im Preview immer angezeigt
  final String safetyNote;

  /// Geplante Sprechdauer in Minuten
  final int durationMinutes;

  const SuggestionScript({
    required this.id,
    required this.sessionId,
    required this.title,
    required this.introText,
    required this.suggestionWords,
    required this.spokenScript,
    required this.safetyNote,
    required this.durationMinutes,
  });
}
