import 'package:flutter/material.dart';
import '../../../core/models/background_sound.dart';

class BackgroundSoundRepository {
  BackgroundSoundRepository._();

  static const List<BackgroundSound> sounds = [
    BackgroundSound(
      id: 'silence',
      title: 'Stille',
      description: 'Kein Hintergrundton – reine Stille',
      assetPath: null,
      icon: Icons.volume_off_rounded,
    ),
    BackgroundSound(
      id: 'ocean',
      title: 'Meeresrauschen',
      description: 'Sanfte Wellen für ein Gefühl von Weite',
      assetPath: 'assets/audio/background/ocean.m4a',
      icon: Icons.waves_rounded,
    ),
    BackgroundSound(
      id: 'rain',
      title: 'Tiefer Regen',
      description: 'Gleichmäßiges Regengeräusch für innere Ruhe',
      assetPath: 'assets/audio/background/rain.m4a',
      icon: Icons.water_drop_rounded,
    ),
    BackgroundSound(
      id: 'purr',
      title: 'Sanftes Schnurren',
      description: 'Tiefes, rhythmisches Schnurren für tiefe Entspannung',
      assetPath: 'assets/audio/background/purr_blacknew.mp3',
      icon: Icons.pets_rounded,
    ),
    BackgroundSound(
      id: 'guitar_soft',
      title: 'Sanfte Gitarre',
      description: 'Ruhige akustische Gitarre für entspannte Momente',
      assetPath: 'assets/audio/background/soft-acoustic-guitar1.mp3',
      icon: Icons.music_note_rounded,
    ),
    BackgroundSound(
      id: 'guitar_slow',
      title: 'Langsame Gitarre',
      description: 'Sehr langsame Gitarrenklänge für tiefe Ruhe',
      assetPath: 'assets/audio/background/very-slow-acoustic-guitar1.mp3',
      icon: Icons.piano_rounded,
    ),
    BackgroundSound(
      id: 'deep_relax',
      title: 'Tiefe Entspannung',
      description: 'Meditativer Klangteppich für vollständige Loslösung',
      assetPath:
          'assets/audio/background/very-slow-relaxing-acoustic-guitar1.mp3',
      icon: Icons.self_improvement_rounded,
    ),
    BackgroundSound(
      id: 'sauna',
      title: 'Sauna Ambiente',
      description: 'Wohlige Wärme-Atmosphäre für tiefe Entspannung',
      assetPath: 'assets/audio/background/warm-sauna-relaxation-ambience1.mp3',
      icon: Icons.local_fire_department_rounded,
    ),
  ];

  static BackgroundSound get silence => sounds.first;

  static BackgroundSound? findById(String id) {
    try {
      return sounds.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
