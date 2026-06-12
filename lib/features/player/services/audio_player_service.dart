import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../../../core/models/background_sound.dart';
import '../../../core/models/hypnosis_session.dart';
import '../../../core/models/sleep_timer_option.dart';

enum PlayerStatus { stopped, playing, paused }

/// Per-sound loading state – separate from [PlayerStatus] so the UI can show
/// an active/loading chip before the audio is actually playing.
enum BackgroundSoundState { loading, playing, error }

class AudioPlayerService extends ChangeNotifier {
  AudioPlayerService._() {
    _voiceSub = _voicePlayer.playbackEventStream.listen(
      (_) {},
      onError: (e, _) => debugPrint('[Voice] playbackEventStream error: $e'),
    );
  }
  static final AudioPlayerService instance = AudioPlayerService._();

  bool _disposed = false;

  // ── Voice ─────────────────────────────────────────────────────────────────
  final AudioPlayer _voicePlayer = AudioPlayer();
  StreamSubscription<PlaybackEvent>? _voiceSub;
  double _voiceVolume = 1.0;

  // Guard against concurrent play() calls for the same or different session.
  bool _voiceBusy = false;

  // ── Background mixer ──────────────────────────────────────────────────────
  // Players are kept alive across toggle cycles – never disposed mid-session.
  final Map<String, AudioPlayer> _bgPlayers = {};
  final Map<String, StreamSubscription<PlaybackEvent>> _bgSubs = {};
  final Map<String, String> _bgAssets = {};
  final Map<String, double> _bgVolumes = {};

  // Sound IDs that the user intends to hear (set BEFORE any async work).
  final List<String> _activeIds = [];

  // Per-sound loading/playing/error state for UI feedback.
  final Map<String, BackgroundSoundState> _bgStates = {};

  // Op-id per sound: incremented on every toggle so stale async ops abort.
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

  /// Returns the per-sound loading state, or null when inactive.
  BackgroundSoundState? backgroundSoundStateFor(String soundId) =>
      _bgStates[soundId];

  bool isBackgroundLoading(String soundId) =>
      _bgStates[soundId] == BackgroundSoundState.loading;

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

  /// Toggles a sound on or off.
  ///
  /// UI state (active + loading indicator) is updated synchronously before any
  /// audio I/O so the button reacts instantly.
  Future<void> toggleBackgroundSound(BackgroundSound sound) async {
    if (sound.isSilence) {
      await stopAllBackgroundSounds();
      return;
    }

    // Bump op-id: any in-flight async work for this sound detects the new id
    // and aborts, preventing stale completions from overwriting newer state.
    _bgOpId[sound.id] = (_bgOpId[sound.id] ?? 0) + 1;
    final opId = _bgOpId[sound.id]!;

    if (isBackgroundActive(sound.id)) {
      // ── DEACTIVATE ────────────────────────────────────────────────────────
      // Immediate UI: remove from active list and clear state.
      _activeIds.remove(sound.id);
      _bgStates.remove(sound.id);
      notifyListeners(); // instant feedback

      await _stopAudioForId(sound.id);
    } else {
      // ── ACTIVATE ──────────────────────────────────────────────────────────
      // Immediate UI: mark sound as active+loading before any async work.
      _activeIds.add(sound.id);
      _bgStates[sound.id] = BackgroundSoundState.loading;
      notifyListeners(); // instant feedback – slider + chip appear now

      await _startAudioForSound(sound, opId: opId);
    }
  }

  Future<void> _startAudioForSound(
    BackgroundSound sound, {
    required int opId,
  }) async {
    if (_disposed || sound.assetPath == null) {
      _activeIds.remove(sound.id);
      _bgStates.remove(sound.id);
      notifyListeners();
      return;
    }

    _bgAssets[sound.id] = sound.assetPath!;
    final volume = _bgVolumes[sound.id] ?? _defaultVolume(sound.id);
    _bgVolumes[sound.id] = volume;

    final player = _bgPlayers.putIfAbsent(sound.id, () {
      final p = AudioPlayer();
      _bgSubs[sound.id] = p.playbackEventStream.listen(
        (_) {},
        onError: (e, _) => debugPrint('[BG] Error ${sound.id}: $e'),
      );
      return p;
    });

    try {
      // Web: hard-stop before (re-)loading to flush the AudioContext cache.
      if (kIsWeb) {
        try { await player.stop(); } catch (_) {}
        await Future.delayed(const Duration(milliseconds: 80));
        if (_disposed || opId != _bgOpId[sound.id]) return;
      }

      // Reload asset when the player has no source or has finished.
      final ps = player.playerState.processingState;
      if (ps == ProcessingState.idle || ps == ProcessingState.completed) {
        await player.setAsset(sound.assetPath!);
        if (_disposed || opId != _bgOpId[sound.id]) return;
      }

      // Wait until ready (max 2 s).
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

      _bgStates[sound.id] = BackgroundSoundState.playing;
      debugPrint('[BG] Gestartet: "${sound.title}" (${(volume * 100).round()}%)');
      notifyListeners();
    } catch (e) {
      debugPrint('[BG] Fehler beim Starten "${sound.title}": $e');
      // Only update state if this op is still current (not preempted).
      if (!_disposed && opId == _bgOpId[sound.id]) {
        _activeIds.remove(sound.id);
        _bgStates[sound.id] = BackgroundSoundState.error;
        notifyListeners();
      }
    }
  }

  Future<void> _stopAudioForId(String soundId) async {
    final player = _bgPlayers[soundId];
    if (player == null) return;
    try {
      await player.stop();
      await player.setVolume(0.0);
      debugPrint('[BG] Gestoppt: $soundId');
    } catch (e) {
      debugPrint('[BG] Fehler beim Stoppen $soundId: $e');
    }
    // Player stays in the pool for fast reuse on next toggle.
  }

  Future<void> stopAllBackgroundSounds() async {
    // Cancel all in-flight ops first.
    for (final id in _activeIds) {
      _bgOpId[id] = (_bgOpId[id] ?? 0) + 1;
    }
    final ids = List<String>.from(_activeIds);
    _activeIds.clear();
    _bgStates.clear();
    notifyListeners(); // instant UI reset

    for (final id in ids) {
      await _stopAudioForId(id);
    }
    debugPrint('[BG] Alle gestoppt.');
  }

  // ── Wiedergabe ────────────────────────────────────────────────────────────

  Future<void> play(HypnosisSession session) async {
    if (_disposed) return;

    // Idempotency: if this exact session is already loading or playing, bail.
    if (_currentSession?.id == session.id &&
        (_voiceBusy || _status == PlayerStatus.playing)) {
      return;
    }

    // Guard against a second concurrent call from a UI double-tap.
    if (_voiceBusy) return;
    _voiceBusy = true;

    // Set session + status immediately so the UI responds before any I/O.
    _currentSession = session;
    _status = PlayerStatus.playing;
    notifyListeners();

    try {
      if (session.audioPath != null) {
        debugPrint('[Voice] Lade: ${session.audioPath}');

        // Web: flush AudioContext before loading a new source.
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

        if (_disposed) return;
        await _voicePlayer.play();
        debugPrint('[Voice] Gestartet: "${session.title}"');
      }
    } catch (e) {
      debugPrint('[Voice] Fehler: $e');
      if (!_disposed) {
        _status = PlayerStatus.stopped;
        notifyListeners();
        return;
      }
    } finally {
      _voiceBusy = false;
    }

    // Resume background players that are registered active but not playing.
    for (final id in List<String>.from(_activeIds)) {
      final player = _bgPlayers[id];
      if (player == null) continue;
      try {
        if (!player.playing) {
          if (player.playerState.processingState == ProcessingState.idle) {
            final path = _bgAssets[id];
            if (path != null) await player.setAsset(path);
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
      // Pause all active background players.
      for (final id in _activeIds) {
        final player = _bgPlayers[id];
        if (player != null) await player.pause();
      }
      debugPrint('[Player] Pausiert (${_activeIds.length} Hintergrund).');
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
      debugPrint('[Player] Fortgesetzt (${_activeIds.length} Hintergrund).');
    } catch (e) {
      debugPrint('[Player] Fehler beim Fortsetzen: $e');
    }
    if (!_disposed) notifyListeners();
  }

  Future<void> stop() async {
    if (_disposed) return;
    try {
      await _voicePlayer.stop();
      // Stop all pooled players to ensure silence.
      for (final player in _bgPlayers.values) {
        await player.stop();
      }
      debugPrint('[Player] Gestoppt (${_bgPlayers.length} Hintergrund).');
    } catch (e) {
      debugPrint('[Player] Fehler beim Stoppen: $e');
    }
    // Keep _activeIds and _bgStates intact for resume after stop.
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
