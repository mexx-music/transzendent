import '../../../core/models/hypnosis_session.dart';
import '../../../core/models/session_category.dart';

/// Statisches Repository – kein Netzwerk, keine Datenbank.
/// In Ausbaustufe 4 kann diese Klasse durch ein echtes Repository
/// mit Remote-Daten oder einer lokalen SQLite-DB ersetzt werden.
class SessionRepository {
  SessionRepository._();

  // ── Kategorien ────────────────────────────────────────────────────────────

  static const List<SessionCategory> categories = [
    SessionCategory(
      id: 'sleep',
      title: 'Schlaf & Ruhe',
      subtitle: 'Lass den Tag los und finde innere Stille',
      iconPath: '',
    ),
    SessionCategory(
      id: 'strength',
      title: 'Mentale Stärke',
      subtitle: 'Stärke dein Selbstvertrauen und deinen Fokus',
      iconPath: '',
    ),
    SessionCategory(
      id: 'release',
      title: 'Loslassen',
      subtitle: 'Befreie dich von Gedanken, die dich belasten',
      iconPath: '',
    ),
  ];

  // ── Sessions ──────────────────────────────────────────────────────────────

  static const List<HypnosisSession> _allSessions = [
    // Schlaf & Ruhe
    HypnosisSession(
      id: 'sleep_1',
      categoryId: 'sleep',
      title: 'Sanft einschlafen',
      description:
          'Eine ruhige geführte Reise in tiefen, erholsamen Schlaf. '
          'Ideal für Abende, an denen der Gedankenstrom nicht zur Ruhe kommt.',
      durationMinutes: 20,
      audioPath: 'assets/audio/voice/deutschhypnose1.mp3',
    ),
    HypnosisSession(
      id: 'sleep_2',
      categoryId: 'sleep',
      title: 'Innere Ruhe',
      description:
          'Atemübungen und mentale Bilder, die das Nervensystem beruhigen '
          'und einen Zustand tiefer Entspannung herbeiführen.',
      durationMinutes: 15,
    ),
    HypnosisSession(
      id: 'sleep_3',
      categoryId: 'sleep',
      title: 'Entspannung in belastenden Zeiten',
      description:
          'Eine sanfte Begleitung für Phasen, in denen Stress und Anspannung '
          'den Alltag bestimmen – ohne Bewertung, ohne Druck.',
      durationMinutes: 25,
      isPremium: true,
    ),

    // Mentale Stärke
    HypnosisSession(
      id: 'strength_1',
      categoryId: 'strength',
      title: 'Selbstvertrauen',
      description:
          'Positive Suggestionen, die das Vertrauen in die eigenen Fähigkeiten '
          'stärken und einen klaren, fokussierten Geisteszustand fördern.',
      durationMinutes: 18,
    ),
    HypnosisSession(
      id: 'strength_2',
      categoryId: 'strength',
      title: 'Positive Morgenenergie',
      description:
          'Starte den Tag mit Klarheit und einem offenen Geist. '
          'Kurze, belebende Suggestionen für den Morgen.',
      durationMinutes: 10,
    ),

    // Loslassen
    HypnosisSession(
      id: 'release_1',
      categoryId: 'release',
      title: 'Gedanken loslassen',
      description:
          'Geführte Visualisierung, um belastende Gedankenmuster zu erkennen '
          'und ihnen sanft Raum zu geben – ohne festzuhalten.',
      durationMinutes: 22,
    ),
    HypnosisSession(
      id: 'release_2',
      categoryId: 'release',
      title: 'Innere Leichtigkeit',
      description:
          'Eine Reise zu mehr innerer Freiheit – ideal nach anspruchsvollen '
          'Phasen im Alltag.',
      durationMinutes: 17,
      isPremium: true,
    ),
  ];

  /// Alle Sessions einer Kategorie zurückgeben.
  static List<HypnosisSession> sessionsForCategory(String categoryId) =>
      _allSessions.where((s) => s.categoryId == categoryId).toList();

  /// Eine Session anhand ihrer ID finden.
  static HypnosisSession? findById(String id) {
    try {
      return _allSessions.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
