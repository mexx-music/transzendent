import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../../../core/models/background_sound.dart';
import '../../../core/models/hypnosis_session.dart';
import '../../../core/models/sleep_timer_option.dart';

enum PlayerStatus { stopped, playing, paused }

class AudioPlayerService extends ChangeNotifier {
  AudioPlayerService._();
  static final AudioPlayerService instance = AudioPlayerService._();

  // ── Voice ─────────────────────────────────────────────────────────────────

  final AudioPlayer _voicePlayer = AudioPlayer();
  double _voiceVolume = 1.0;

  // ── Background mixer ──────────────────────────────────────────────────────

  /// One AudioPlayer per active background sound, keyed by soundId.
  final Map<String, AudioPlayer> _backgroundPlayers = {};

  /// Volume preferences – persist across toggle cycles.
  final Map<String, double> _backgroundVolumes = {};

  /// Ordered list of active sound IDs (insertion order preserved).
  final List<String> _activeBackgroundSoundIds = [];

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

  bool get hasActiveBackground => _activeBackgroundSoundIds.isNotEmpty;
  int get activeBackgroundCount => _activeBackgroundSoundIds.length;

  /// Unmodifiable snapshot for UI display (ordered by activation).
  List<String> get activeBackgroundSoundIds =>
      List.unmodifiable(_activeBackgroundSoundIds);

  bool isBackgroundActive(String soundId) =>
      _activeBackgroundSoundIds.contains(soundId);

  double backgroundVolumeFor(String soundId) =>
      _backgroundVolumes[soundId] ?? _defaultVolume(soundId);

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
    _backgroundVolumes[soundId] = value.clamp(0.0, 1.0);
    final player = _backgroundPlayers[soundId];
    if (player != null) {
      await player.setVolume(_backgroundVolumes[soundId]!);
    }
    notifyListeners();
  }

  // ── Hintergrund-Mixer ─────────────────────────────────────────────────────

  /// Toggles a background sound on or off.
  /// Silence chip calls this too – it acts as "stop all".
  Future<void> toggleBackgroundSound(BackgroundSound sound) async {
    if (sound.isSilence) {
      await stopAllBackgroundSounds();
      return;
    }

    if (isBackgroundActive(sound.id)) {
      await _stopSingleBackground(sound.id);
    } else {
      await _startSingleBackground(sound);
    }

    notifyListeners();
  }

  Future<void> _startSingleBackground(BackgroundSound sound) async {
    final volume = _backgroundVolumes[sound.id] ?? _defaultVolume(sound.id);
    _backgroundVolumes[sound.id] = volume;

    final player = AudioPlayer();
    try {
      await player.setAsset(sound.assetPath!);
      await player.setLoopMode(LoopMode.all);
      await player.setVolume(volume);
      await player.play();
      _backgroundPlayers[sound.id] = player;
      _activeBackgroundSoundIds.add(sound.id);
      debugPrint(
        '[Background] Gestartet: "${sound.title}" '
        '(${(volume * 100).round()}%)',
      );
    } catch (e) {
      debugPrint(
        '[Background] Fehler beim Starten "${sound.title}" '
        '– Session läuft weiter: $e',
      );
      await player.dispose();
    }
  }

  Future<void> _stopSingleBackground(String soundId) async {
    final player = _backgroundPlayers.remove(soundId);
    _activeBackgroundSoundIds.remove(soundId);
    try {
      await player?.stop();
      await player?.dispose();
      debugPrint('[Background] Gestoppt: $soundId');
    } catch (e) {
      debugPrint('[Background] Fehler beim Stoppen $soundId: $e');
    }
  }

  Future<void> stopAllBackgroundSounds() async {
    final ids = List<String>.from(_activeBackgroundSoundIds);
    for (final id in ids) {
      await _stopSingleBackground(id);
    }
    debugPrint('[Background] Alle gestoppt.');
    notifyListeners();
  }

  // ── Wiedergabe ────────────────────────────────────────────────────────────

  Future<void> play(HypnosisSession session) async {
    if (session.audioPath == null) {
      debugPrint(
        '[Voice] Kein audioPath für "${session.title}" – übersprungen.',
      );
      _currentSession = session;
      _status = PlayerStatus.playing;
    } else {
      try {
        debugPrint('[Voice] Lade: ${session.audioPath}');
        if (_currentSession?.id != session.id) {
          await _voicePlayer.stop();
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

    // Resume any stopped-but-still-registered background players.
    for (final entry in _backgroundPlayers.entries) {
      try {
        if (!entry.value.playing) {
          await entry.value.play();
          debugPrint('[Background] Fortgesetzt: ${entry.key}');
        }
      } catch (e) {
        debugPrint('[Background] Fehler beim Fortsetzen ${entry.key}: $e');
      }
    }

    notifyListeners();
  }

  Future<void> pause() async {
    try {
      await _voicePlayer.pause();
      for (final entry in _backgroundPlayers.entries) {
        await entry.value.pause();
      }
      debugPrint(
        '[Player] Pausiert (Stimme + ${_backgroundPlayers.length} Hintergrund).',
      );
    } catch (e) {
      debugPrint('[Player] Fehler beim Pausieren: $e');
    }
    _status = PlayerStatus.paused;
    notifyListeners();
  }

  Future<void> resume() async {
    if (_status != PlayerStatus.paused) return;
    try {
      await _voicePlayer.play();
      for (final entry in _backgroundPlayers.entries) {
        await entry.value.play();
      }
      _status = PlayerStatus.playing;
      debugPrint(
        '[Player] Fortgesetzt (Stimme + ${_backgroundPlayers.length} Hintergrund).',
      );
    } catch (e) {
      debugPrint('[Player] Fehler beim Fortsetzen: $e');
    }
    notifyListeners();
  }

  Future<void> stop() async {
    try {
      await _voicePlayer.stop();
      for (final entry in _backgroundPlayers.entries) {
        await entry.value.stop();
      }
      debugPrint(
        '[Player] Gestoppt (Stimme + ${_backgroundPlayers.length} Hintergrund).',
      );
    } catch (e) {
      debugPrint('[Player] Fehler beim Stoppen: $e');
    }
    // Keep players/volumes for restart – clear status only.
    _status = PlayerStatus.stopped;
    notifyListeners();
  }

  @override
  void dispose() {
    _voicePlayer.dispose();
    for (final player in _backgroundPlayers.values) {
      player.dispose();
    }
    super.dispose();
  }
}
