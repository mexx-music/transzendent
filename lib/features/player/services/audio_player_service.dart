import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../../../core/models/background_sound.dart';
import '../../../core/models/hypnosis_session.dart';
import '../../../core/models/sleep_timer_option.dart';

enum PlayerStatus { stopped, playing, paused }

class AudioPlayerService extends ChangeNotifier {
  AudioPlayerService._() {
    _voiceSub = _voicePlayer.playbackEventStream.listen(
      (_) {},
      onError: (e, st) => debugPrint('[Voice] playbackEventStream error: $e'),
    );
  }
  static final AudioPlayerService instance = AudioPlayerService._();

  bool _disposed = false;

  // ── Voice ─────────────────────────────────────────────────────────────────
  final AudioPlayer _voicePlayer = AudioPlayer();
  StreamSubscription<PlaybackEvent>? _voiceSub;
  double _voiceVolume = 1.0;

  // ── Background mixer ──────────────────────────────────────────────────────
  // Players are kept alive across toggle cycles – never disposed mid-session.
  // This mirrors the Schnurr pattern: pre-allocate once, reuse always.
  final Map<String, AudioPlayer> _bgPlayers = {};
  final Map<String, StreamSubscription<PlaybackEvent>> _bgSubs = {};
  final Map<String, String> _bgAssets = {};   // cached assetPath for reload
  final Map<String, double> _bgVolumes = {};
  final List<String> _activeIds = [];

  // Concurrency guards per sound (busy flag + op-id for stale detection)
  final Map<String, bool> _bgBusy = {};
  final Map<String, int> _bgOpId = {};

  // ── Session state ─────────────────────────────────────────────────────────
  PlayerStatus _status = PlayerStatus.stopped;
  HypnosisSession? _currentSession;
  SleepTimerOption? _timerOption;

  // ── Getters ───────────────────────────────────────────────────────────────
  PlayerStatus get status => _status;
  HypnosisSession? get currentSession => _currentSession;
  SleepTimerOption? get timerOption => _timerOption;
  double get voiceVolume => _voiceVolume;

  bool get isPlaying => _status == PlayerStatus.playing;
  bool get isPaused => _status == PlayerStatus.paused;
  bool get isStopped => _status == PlayerStatus.stopped;

  bool get hasActiveBackground => _activeIds.isNotEmpty;
  int get activeBackgroundCount => _activeIds.length;

  List<String> get activeBackgroundSoundIds => List.unmodifiable(_activeIds);

  bool isBackgroundActive(String soundId) => _activeIds.contains(soundId);

  double backgroundVolumeFor(String soundId) =>
      _bgVolumes[soundId] ?? _defaultVolume(soundId);

  double _defaultVolume(String soundId) => switch (soundId) {
    'purr' => 0.25,
    'rain' || 'ocean' => 0.30,
    'guitar_soft' || 'guitar_slow' || 'deep_relax' => 0.20,
    'sauna' => 0.18,
    _ => 0.20,
  };

  // ── Timer ─────────────────────────────────────────────────────────────────
  void setTimerOption(SleepTimerOption option) {
    _timerOption = option;
    debugPrint(
      '[Player] Timer: '
      '${option.isUnlimited ? "kein Timer" : "${option.durationMinutes} min"}',
    );
    notifyListeners();
  }

  // ── Lautstärke ────────────────────────────────────────────────────────────
  Future<void> setVoiceVolume(double value) async {
    _voiceVolume = value.clamp(0.0, 1.0);
    await _voicePlayer.setVolume(_voiceVolume);
    notifyListeners();
  }

  Future<void> setBackgroundSoundVolume(String soundId, double value) async {
    _bgVolumes[soundId] = value.clamp(0.0, 1.0);
    final player = _bgPlayers[soundId];
    if (player != null) {
      await player.setVolume(_bgVolumes[soundId]!);
    }
    notifyListeners();
  }

  // ── Hintergrund-Mixer ─────────────────────────────────────────────────────

  /// Toggles a background sound on or off.
  /// Silence chip acts as "stop all".
  Future<void> toggleBackgroundSound(BackgroundSound sound) async {
    if (sound.isSilence) {
      await stopAllBackgroundSounds();
      return;
    }

    // Busy guard: ignore rapid double-taps that would race async operations.
    if (_bgBusy[sound.id] == true) return;
    _bgBusy[sound.id] = true;
    _bgOpId[sound.id] = (_bgOpId[sound.id] ?? 0) + 1;
    final opId = _bgOpId[sound.id]!;

    try {
      if (isBackgroundActive(sound.id)) {
        await _deactivateBackground(sound.id, opId: opId);
      } else {
        await _activateBackground(sound, opId: opId);
      }
      if (_disposed || opId != _bgOpId[sound.id]) return;
      notifyListeners();
    } finally {
      _bgBusy[sound.id] = false;
    }
  }

  Future<void> _activateBackground(
    BackgroundSound sound, {
    required int opId,
  }) async {
    if (_disposed || sound.assetPath == null) return;

    final volume = _bgVolumes[sound.id] ?? _defaultVolume(sound.id);
    _bgVolumes[sound.id] = volume;
    _bgAssets[sound.id] = sound.assetPath!;

    // Reuse existing player or create a new one and register it in the pool.
    final player = _bgPlayers.putIfAbsent(sound.id, () {
      final p = AudioPlayer();
      _bgSubs[sound.id] = p.playbackEventStream.listen(
        (_) {},
        onError: (e, _) => debugPrint('[BG] Error ${sound.id}: $e'),
      );
      return p;
    });

    try {
      // Web: must hard-stop before (re-)loading to flush the AudioContext cache.
      if (kIsWeb) {
        try { await player.stop(); } catch (_) {}
        await Future.delayed(const Duration(milliseconds: 80));
        if (_disposed || opId != _bgOpId[sound.id]) return;
      }

      // Reload asset when the player has no source (idle) or has finished.
      final ps = player.playerState.processingState;
      if (ps == ProcessingState.idle || ps == ProcessingState.completed) {
        await player.setAsset(sound.assetPath!);
        if (_disposed || opId != _bgOpId[sound.id]) return;
      }

      // Wait until the player signals it is ready to play (max 2 s).
      try {
        await player.playerStateStream
            .firstWhere((s) =>
                s.processingState == ProcessingState.ready ||
                s.processingState == ProcessingState.buffering)
            .timeout(const Duration(seconds: 2));
      } catch (_) {}
      if (_disposed || opId != _bgOpId[sound.id]) return;

      await player.setLoopMode(LoopMode.all);
      await player.setVolume(volume);
      await player.seek(Duration.zero);
      await player.play();

      if (_disposed || opId != _bgOpId[sound.id]) return;
      _activeIds.add(sound.id);
      debugPrint(
        '[BG] Gestartet: "${sound.title}" (${(volume * 100).round()}%)',
      );
    } catch (e) {
      debugPrint('[BG] Fehler beim Starten "${sound.title}": $e');
    }
  }

  Future<void> _deactivateBackground(String soundId, {int? opId}) async {
    _activeIds.remove(soundId);
    final player = _bgPlayers[soundId];
    if (player == null) return;
    try {
      await player.stop();
      await player.setVolume(0.0);
      debugPrint('[BG] Gestoppt: $soundId');
    } catch (e) {
      debugPrint('[BG] Fehler beim Stoppen $soundId: $e');
    }
    // Player stays in the pool so it can be reused quickly on next toggle.
  }

  Future<void> stopAllBackgroundSounds() async {
    final ids = List<String>.from(_activeIds);
    for (final id in ids) {
      await _deactivateBackground(id);
    }
    debugPrint('[BG] Alle gestoppt.');
    notifyListeners();
  }

  // ── Wiedergabe ────────────────────────────────────────────────────────────

  Future<void> play(HypnosisSession session) async {
    if (_disposed) return;

    if (session.audioPath == null) {
      debugPrint('[Voice] Kein audioPath – übersprungen.');
      _currentSession = session;
      _status = PlayerStatus.playing;
    } else {
      try {
        debugPrint('[Voice] Lade: ${session.audioPath}');
        if (_currentSession?.id != session.id) {
          // Web: stop first to flush AudioContext before loading new source.
          if (kIsWeb) {
            try { await _voicePlayer.stop(); } catch (_) {}
            await Future.delayed(const Duration(milliseconds: 80));
          } else {
            await _voicePlayer.stop();
          }
          if (_disposed) return;
          await _voicePlayer.setAsset(session.audioPath!);
          await _voicePlayer.setVolume(_voiceVolume);
          debugPrint('[Voice] Asset geladen.');
        }
        _currentSession = session;
        await _voicePlayer.play();
        _status = PlayerStatus.playing;
        debugPrint('[Voice] Gestartet: "${session.title}"');
      } catch (e) {
        debugPrint('[Voice] Fehler: $e');
        _currentSession = session;
        _status = PlayerStatus.stopped;
      }
    }

    // Resume background players that are registered as active but not playing.
    for (final id in List<String>.from(_activeIds)) {
      final player = _bgPlayers[id];
      if (player == null) continue;
      try {
        if (!player.playing) {
          // After stop(), just_audio may leave the player in idle state.
          // Reload asset from cache if needed before calling play().
          if (player.playerState.processingState == ProcessingState.idle) {
            final assetPath = _bgAssets[id];
            if (assetPath != null) await player.setAsset(assetPath);
          }
          await player.setLoopMode(LoopMode.all);
          await player.seek(Duration.zero);
          await player.play();
          debugPrint('[BG] Fortgesetzt: $id');
        }
      } catch (e) {
        debugPrint('[BG] Fehler beim Fortsetzen $id: $e');
      }
    }

    if (!_disposed) notifyListeners();
  }

  Future<void> pause() async {
    if (_disposed) return;
    try {
      await _voicePlayer.pause();
      for (final player in _bgPlayers.values) {
        await player.pause();
      }
      debugPrint(
        '[Player] Pausiert (Stimme + ${_activeIds.length} Hintergrund).',
      );
    } catch (e) {
      debugPrint('[Player] Fehler beim Pausieren: $e');
    }
    _status = PlayerStatus.paused;
    if (!_disposed) notifyListeners();
  }

  Future<void> resume() async {
    if (_disposed || _status != PlayerStatus.paused) return;
    try {
      await _voicePlayer.play();
      // Only resume sounds that were active before the pause.
      for (final id in _activeIds) {
        final player = _bgPlayers[id];
        if (player != null) await player.play();
      }
      _status = PlayerStatus.playing;
      debugPrint(
        '[Player] Fortgesetzt (Stimme + ${_activeIds.length} Hintergrund).',
      );
    } catch (e) {
      debugPrint('[Player] Fehler beim Fortsetzen: $e');
    }
    if (!_disposed) notifyListeners();
  }

  Future<void> stop() async {
    if (_disposed) return;
    try {
      await _voicePlayer.stop();
      // Stop all pooled players (active or not) to ensure silence.
      for (final player in _bgPlayers.values) {
        await player.stop();
      }
      debugPrint(
        '[Player] Gestoppt (Stimme + ${_bgPlayers.length} Hintergrund).',
      );
    } catch (e) {
      debugPrint('[Player] Fehler beim Stoppen: $e');
    }
    // Keep _activeIds and volumes intact for the next play() call.
    _status = PlayerStatus.stopped;
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _voiceSub?.cancel();
    _voicePlayer.dispose();
    for (final sub in _bgSubs.values) {
      sub.cancel();
    }
    for (final player in _bgPlayers.values) {
      player.dispose();
    }
    super.dispose();
  }
}
