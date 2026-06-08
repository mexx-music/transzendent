/// Datenmodell für eine einzelne Hypnose- oder Entspannungs-Session.
class HypnosisSession {
  final String id;
  final String categoryId; // Verknüpfung zur SessionCategory.id
  final String title;
  final String description;

  /// Geplante Länge in Minuten – Platzhalter bis Audio-Feature integriert ist.
  final int durationMinutes;

  /// Premium-Flag – für spätere In-App-Purchase-Logik.
  final bool isPremium;

  /// Pfad zur Audio-Datei – wird in Ausbaustufe 3 (Player) befüllt.
  final String? audioPath;

  const HypnosisSession({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.durationMinutes,
    this.isPremium = false,
    this.audioPath,
  });
}
