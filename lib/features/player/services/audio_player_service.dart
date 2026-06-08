import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../../../core/models/background_sound.dart';
import '../../../core/models/hypnosis_session.dart';
import '../../../core/models/sleep_timer_option.dart';

enum PlayerStatus { stopped, playing, paused }

class AudioPlayerService extends ChangeNotifier {
  AudioPlayerService._();
  static final AudioPlayerService instance = AudioPlayerService._();

  final AudioPlayer _voicePlayer = AudioPlayer();
  final AudioPlayer _backgroundPlayer = AudioPlayer();

  PlayerStatus _status = PlayerStatus.stopped;
  HypnosisSession? _currentSession;
  SleepTimerOption? _timerOption;
  BackgroundSound? _selectedBackgroundSound;

  double _voiceVolume = 1.0;
  double _backgroundVolume = 0.35;

  PlayerStatus get status => _status;
  HypnosisSession? get currentSession => _currentSession;
  SleepTimerOption? get timerOption => _timerOption;
  BackgroundSound? get selectedBackgroundSound => _selectedBackgroundSound;
  double get voiceVolume => _voiceVolume;
  double get backgroundVolume => _backgroundVolume;

  bool get isPlaying => _status == PlayerStatus.playing;
  bool get isPaused => _status == PlayerStatus.paused;
  bool get isStopped => _status == PlayerStatus.stopped;
  bool get hasActiveBackground =>
      _selectedBackgroundSound != null &&
      !_selectedBackgroundSound!.isSilence;

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

  Future<void> setBackgroundVolume(double value) async {
    _backgroundVolume = value.clamp(0.0, 1.0);
    await _backgroundPlayer.setVolume(_backgroundVolume);
    notifyListeners();
  }

  // ── Wiedergabe ────────────────────────────────────────────────────────────

  Future<void> play(
    HypnosisSession session, {
    BackgroundSound? backgroundSound,
  }) async {
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

    if (backgroundSound != null) {
      await playBackground(backgroundSound);
    } else {
      notifyListeners();
    }
  }

  Future<void> playBackground(BackgroundSound sound) async {
    _selectedBackgroundSound = sound;

    if (sound.isSilence) {
      try {
        await _backgroundPlayer.stop();
        debugPrint('[Background] Gestoppt (Stille).');
      } catch (e) {
        debugPrint('[Background] Fehler beim Stoppen: $e');
      }
      notifyListeners();
      return;
    }

    try {
      debugPrint('[Background] Lade: ${sound.assetPath}');
      await _backgroundPlayer.stop();
      await _backgroundPlayer.setAsset(sound.assetPath!);
      await _backgroundPlayer.setLoopMode(LoopMode.all);
      await _backgroundPlayer.setVolume(_backgroundVolume);
      await _backgroundPlayer.play();
      debugPrint('[Background] Gestartet (loop): "${sound.title}"');
    } catch (e) {
      debugPrint('[Background] Fehler – Session läuft weiter: $e');
    }

    notifyListeners();
  }

  Future<void> stopBackground() async {
    try {
      await _backgroundPlayer.stop();
      debugPrint('[Background] Gestoppt.');
    } catch (e) {
      debugPrint('[Background] Fehler beim Stoppen: $e');
    }
    _selectedBackgroundSound = null;
    notifyListeners();
  }

  Future<void> pause() async {
    try {
      await _voicePlayer.pause();
      await _backgroundPlayer.pause();
      debugPrint('[Player] Pausiert (beide Tracks).');
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
      if (hasActiveBackground) {
        await _backgroundPlayer.play();
      }
      _status = PlayerStatus.playing;
      debugPrint('[Player] Fortgesetzt (beide Tracks).');
    } catch (e) {
      debugPrint('[Player] Fehler beim Fortsetzen: $e');
    }
    notifyListeners();
  }

  Future<void> stop() async {
    try {
      await _voicePlayer.stop();
      await _backgroundPlayer.stop();
      debugPrint('[Player] Gestoppt (beide Tracks).');
    } catch (e) {
      debugPrint('[Player] Fehler beim Stoppen: $e');
    }
    _status = PlayerStatus.stopped;
    _selectedBackgroundSound = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _voicePlayer.dispose();
    _backgroundPlayer.dispose();
    super.dispose();
  }
}
