import '../../../core/models/suggestion_script.dart';

/// Statisches Repository für Suggestions-Texte.
///
/// Ausbaustufe 6+: Kann durch ein Remote-Repository (REST, Firestore)
/// oder eine lokale SQLite-DB ersetzt werden, ohne den Rest der App zu ändern.
class SuggestionRepository {
  SuggestionRepository._();

  static const String _safetyNote =
      'Diese Inhalte dienen der Entspannung und Förderung des allgemeinen '
      'Wohlbefindens. Sie ersetzen keine medizinische oder psychologische '
      'Beratung. Bei gesundheitlichen Beschwerden wende dich bitte an eine '
      'Fachkraft.';

  static const List<SuggestionScript> _scripts = [
    // ── Schlaf & Ruhe ────────────────────────────────────────────────────────
    SuggestionScript(
      id: 'script_sleep_1',
      sessionId: 'sleep_1',
      title: 'Sanftes Einschlafen',
      introText:
          'Diese Suggestion begleitet dich mit ruhigen Bildern und sanften '
          'Worten in einen tiefen, erholsamen Schlaf.',
      suggestionWords: [
        'Ruhe',
        'Leichtigkeit',
        'Loslassen',
        'Geborgenheit',
        'Stille',
      ],
      spokenScript:
          'Finde eine angenehme Position und schließe die Augen.\n\n'
          'Atme tief ein … und langsam aus.\n\n'
          'Spüre, wie sich dein Körper mit jedem Atemzug etwas mehr entspannt.\n\n'
          'Du bist geborgen. Du bist sicher. Du darfst loslassen.\n\n'
          'Stell dir vor, wie eine sanfte Wärme durch deinen Körper fließt – '
          'von den Zehen aufwärts, durch die Beine, den Rücken, die Schultern.\n\n'
          'Dein Geist wird ruhiger … und ruhiger … und ruhiger.\n\n'
          'Du gleitest sanft in einen tiefen, erholsamen Schlaf.',
      safetyNote: _safetyNote,
      durationMinutes: 20,
    ),
    SuggestionScript(
      id: 'script_sleep_2',
      sessionId: 'sleep_2',
      title: 'Innere Stille',
      introText:
          'Atemübungen und ruhige Bilder führen dich in einen Zustand tiefer '
          'innerer Stille.',
      suggestionWords: ['Atem', 'Stille', 'Entspannung', 'Gleichgewicht'],
      spokenScript:
          'Schließe die Augen und richte deine Aufmerksamkeit auf deinen Atem.\n\n'
          'Einatmen … zwei … drei … vier.\n'
          'Ausatmen … zwei … drei … vier … fünf … sechs.\n\n'
          'Lass jeden Gedanken, der auftaucht, einfach vorbeiziehen – '
          'wie Wolken am Himmel.\n\n'
          'Du musst nichts tun. Du musst nirgendwo sein.\n\n'
          'In diesem Moment ist alles in Ordnung.\n\n'
          'Spüre die Stille in dir.',
      safetyNote: _safetyNote,
      durationMinutes: 15,
    ),
    SuggestionScript(
      id: 'script_sleep_3',
      sessionId: 'sleep_3',
      title: 'Entspannung in belastenden Zeiten',
      introText:
          'Eine sanfte Begleitung für Phasen, in denen Anspannung den Alltag '
          'bestimmt – ohne Bewertung, ohne Druck.',
      suggestionWords: ['Akzeptanz', 'Sanftheit', 'Pause', 'Fürsorge'],
      spokenScript:
          'Es ist in Ordnung, dass du gerade hier bist.\n\n'
          'Du musst dich nicht erklären. Du musst nicht funktionieren.\n\n'
          'Atme tief ein und erlaube dir, einfach zu sein.\n\n'
          'Stell dir vor, du sitzt an einem ruhigen Ort – vielleicht in der '
          'Natur, vielleicht in einem warmen Zimmer.\n\n'
          'Alles, was dich belastet, darf für diesen Moment zur Seite treten.\n\n'
          'Du bist gut so, wie du bist. Du verdienst Ruhe.\n\n'
          'Lass die Schwere sinken … Schicht für Schicht.',
      safetyNote: _safetyNote,
      durationMinutes: 25,
    ),

    // ── Mentale Stärke ───────────────────────────────────────────────────────
    SuggestionScript(
      id: 'script_strength_1',
      sessionId: 'strength_1',
      title: 'Vertrauen in dich selbst',
      introText:
          'Positive Suggestionen, die das Vertrauen in die eigenen Fähigkeiten '
          'stärken und einen klaren Geisteszustand fördern.',
      suggestionWords: [
        'Selbstvertrauen',
        'Fokus',
        'Klarheit',
        'Stärke',
        'Vertrauen',
      ],
      spokenScript:
          'Atme tief ein und richte deine Aufmerksamkeit nach innen.\n\n'
          'Du hast bereits vieles geschafft. Du trägst Ressourcen in dir, '
          'die größer sind, als du manchmal glaubst.\n\n'
          'Stell dir vor, wie du einen Weg vor dir siehst – klar und offen.\n\n'
          'Mit jedem Schritt wächst dein Vertrauen. Du weißt, dass du fähig bist.\n\n'
          'Du bist ruhig. Du bist fokussiert. Du vertraust dir selbst.\n\n'
          'Diese Klarheit begleitet dich durch deinen Tag.',
      safetyNote: _safetyNote,
      durationMinutes: 18,
    ),
    SuggestionScript(
      id: 'script_strength_2',
      sessionId: 'strength_2',
      title: 'Offenheit für den neuen Tag',
      introText:
          'Kurze, belebende Suggestionen für den Morgen – für einen klaren '
          'und offenen Start.',
      suggestionWords: ['Morgen', 'Offenheit', 'Energie', 'Neubeginn'],
      spokenScript:
          'Ein neuer Tag beginnt. Du bist ausgeruht und bereit.\n\n'
          'Atme tief ein und spüre die Frische des Morgens.\n\n'
          'Heute darfst du neugierig sein. Heute darfst du offen sein.\n\n'
          'Was auch immer dieser Tag bringt – du begegnest ihm mit Ruhe '
          'und einem klaren Geist.\n\n'
          'Du bist bereit.',
      safetyNote: _safetyNote,
      durationMinutes: 10,
    ),

    // ── Loslassen ────────────────────────────────────────────────────────────
    SuggestionScript(
      id: 'script_release_1',
      sessionId: 'release_1',
      title: 'Gedanken ziehen lassen',
      introText:
          'Eine geführte Visualisierung, um belastende Gedankenmuster zu '
          'erkennen und ihnen sanft Raum zu geben.',
      suggestionWords: ['Loslassen', 'Freiheit', 'Leichtigkeit', 'Fluss'],
      spokenScript:
          'Atme tief ein. Atme langsam aus.\n\n'
          'Stell dir vor, du sitzt am Ufer eines ruhigen Flusses.\n\n'
          'Gedanken kommen … und gehen. Wie Blätter auf dem Wasser.\n\n'
          'Du musst keinen Gedanken festhalten. Du musst keinen Gedanken '
          'beurteilen.\n\n'
          'Beobachte einfach, wie sie vorbeiziehen – ruhig und gleichmütig.\n\n'
          'Mit jedem Atemzug wirst du leichter.\n\n'
          'Du lässt los. Du bist frei.',
      safetyNote: _safetyNote,
      durationMinutes: 22,
    ),
    SuggestionScript(
      id: 'script_release_2',
      sessionId: 'release_2',
      title: 'Innere Leichtigkeit finden',
      introText:
          'Eine Reise zu mehr innerer Freiheit – ideal nach anspruchsvollen '
          'Phasen im Alltag.',
      suggestionWords: ['Leichtigkeit', 'Frieden', 'Weite', 'Freiheit'],
      spokenScript:
          'Schließe die Augen und lass die Last des Tages sinken.\n\n'
          'Stell dir eine weite, offene Landschaft vor – vielleicht ein '
          'stilles Tal oder einen klaren Himmel.\n\n'
          'In dieser Weite gibt es Raum für alles, was du bist.\n\n'
          'Du musst dich nicht kleiner machen. Du musst nicht kämpfen.\n\n'
          'Atme die Weite ein. Atme Enge aus.\n\n'
          'Spüre die Leichtigkeit, die entsteht, wenn du einfach bist.\n\n'
          'Du bist leicht. Du bist frei. Du bist in Frieden.',
      safetyNote: _safetyNote,
      durationMinutes: 17,
    ),
  ];

  /// Script für eine Session-ID zurückgeben (oder null wenn keins existiert).
  static SuggestionScript? forSession(String sessionId) {
    try {
      return _scripts.firstWhere((s) => s.sessionId == sessionId);
    } catch (_) {
      return null;
    }
  }

  /// Alle Scripts zurückgeben.
  static List<SuggestionScript> get all => _scripts;
}
