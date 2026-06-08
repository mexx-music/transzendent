import 'package:flutter/foundation.dart';

/// In-Memory-Bibliothek für Favoriten und zuletzt gespielte Sessions.
///
/// Singleton, ChangeNotifier – reaktiv via ListenableBuilder nutzbar.
///
/// TODO (Ausbaustufe 8 – Persistenz):
///   SharedPreferences ergänzen:
///   - In toggleFavorite / markRecentlyPlayed nach _write() aufrufen
///   - _write(): prefs.setStringList('favorites', _favoriteIds.toList())
///              prefs.setStringList('recent', _recentIds)
///   - Beim App-Start in initState / main() _load() aufrufen:
///     _favoriteIds = Set.from(prefs.getStringList('favorites') ?? [])
///     _recentIds   = prefs.getStringList('recent') ?? []
class LibraryService extends ChangeNotifier {
  LibraryService._();

  static final LibraryService instance = LibraryService._();

  // ── Interner State ────────────────────────────────────────────────────────

  final Set<String> _favoriteIds = {};

  /// Zuletzt gespielte Session-IDs – neueste zuerst, max. [_maxRecent] Einträge
  final List<String> _recentIds = [];
  static const int _maxRecent = 20;

  // ── Öffentliche Getter ────────────────────────────────────────────────────

  Set<String> get favoriteSessionIds => Set.unmodifiable(_favoriteIds);
  List<String> get recentSessionIds => List.unmodifiable(_recentIds);

  bool isFavorite(String sessionId) => _favoriteIds.contains(sessionId);

  // ── Öffentliche API ───────────────────────────────────────────────────────

  /// Favorit hinzufügen oder entfernen.
  void toggleFavorite(String sessionId) {
    if (_favoriteIds.contains(sessionId)) {
      _favoriteIds.remove(sessionId);
    } else {
      _favoriteIds.add(sessionId);
    }
    notifyListeners();
  }

  /// Session als kürzlich gespielt markieren.
  /// Duplikate werden an den Anfang verschoben.
  void markRecentlyPlayed(String sessionId) {
    _recentIds.remove(sessionId); // Duplikat entfernen
    _recentIds.insert(0, sessionId);
    if (_recentIds.length > _maxRecent) {
      _recentIds.removeLast();
    }
    notifyListeners();
  }
}
