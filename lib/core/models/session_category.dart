/// Datenmodell für eine Session-Kategorie.
class SessionCategory {
  /// Eindeutige ID – wird als Schlüssel für Session-Filterung verwendet.
  final String id;
  final String title;
  final String subtitle;
  final String iconPath; // Platzhalter für spätere Asset-Icons

  const SessionCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconPath,
  });
}
