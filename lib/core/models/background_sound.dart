import 'package:flutter/material.dart';

/// Modell für einen Hintergrund-Sound.
class BackgroundSound {
  final String id;
  final String title;
  final String description;

  /// Pfad zur Asset-Datei – leer / null bedeutet Stille (kein Audio).
  /// Wird in Ausbaustufe 6 mit echten Dateien befüllt.
  final String? assetPath;

  /// Material-Icon als visuelles Identifier in der Auswahl-UI
  final IconData icon;

  final bool isPremium;

  const BackgroundSound({
    required this.id,
    required this.title,
    required this.description,
    this.assetPath,
    required this.icon,
    this.isPremium = false,
  });

  /// Stille – kein Audio, immer verfügbar
  bool get isSilence => assetPath == null || assetPath!.isEmpty;
}
