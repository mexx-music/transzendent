import 'package:flutter/material.dart';
import '../../../core/models/background_sound.dart';

/// Statisches Repository für Hintergrund-Sounds.
///
/// Ausbaustufe 6+: [assetPath] pro Sound eintragen und Dateien unter
/// assets/audio/bg/ ablegen. Dann im AudioPlayerService einen zweiten
/// just_audio-Player für den Hintergrundton starten.
class BackgroundSoundRepository {
  BackgroundSoundRepository._();

  static const List<BackgroundSound> sounds = [
    BackgroundSound(
      id: 'silence',
      title: 'Stille',
      description: 'Kein Hintergrundton – reine Stille',
      assetPath: null, // Stille: kein Asset
      icon: Icons.volume_off_rounded,
    ),
    BackgroundSound(
      id: 'purr',
      title: 'Sanftes Schnurren',
      description: 'Tiefes, rhythmisches Schnurren für tiefe Entspannung',
      assetPath: '', // TODO: 'assets/audio/bg/purr.mp3'
      icon: Icons.pets_rounded,
    ),
    BackgroundSound(
      id: 'rain',
      title: 'Tiefer Regen',
      description: 'Gleichmäßiges Regengeräusch für innere Ruhe',
      assetPath: '', // TODO: 'assets/audio/bg/rain.mp3'
      icon: Icons.water_drop_rounded,
    ),
    BackgroundSound(
      id: 'ocean',
      title: 'Meeresrauschen',
      description: 'Sanfte Wellen für ein Gefühl von Weite',
      assetPath: '', // TODO: 'assets/audio/bg/ocean.mp3'
      icon: Icons.waves_rounded,
    ),
    BackgroundSound(
      id: 'heartbeat',
      title: 'Ruhiger Herzton',
      description: 'Langsamer Herzschlag zur Beruhigung des Nervensystems',
      assetPath: '', // TODO: 'assets/audio/bg/heartbeat.mp3'
      icon: Icons.favorite_rounded,
      isPremium: true,
    ),
    BackgroundSound(
      id: 'drone',
      title: 'Mystischer Drone',
      description: 'Tiefer, meditativer Klang für tiefe Versenkung',
      assetPath: '', // TODO: 'assets/audio/bg/drone.mp3'
      icon: Icons.blur_on_rounded,
      isPremium: true,
    ),
  ];

  /// Stille-Eintrag – immer der erste
  static BackgroundSound get silence => sounds.first;

  /// Sound anhand der ID finden
  static BackgroundSound? findById(String id) {
    try {
      return sounds.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
