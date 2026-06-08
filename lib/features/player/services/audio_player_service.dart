import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../../../core/models/hypnosis_session.dart';
import '../../../core/models/sleep_timer_option.dart';

enum PlayerStatus { stopped, playing, paused }

/// Zentraler Audio-Service – Singleton, ChangeNotifier.
///
/// Ausbaustufe 5 – TODO Hintergrund-Sound:
///   Einen zweiten [AudioPlayer] (_bgPlayer) ergänzen, der unabhängig vom
///   Session-Player läuft. [BackgroundSound.assetPath] wird per
///   _bgPlayer.setAsset(...) geladen und geloopt (LoopMode.all).
///
/// Ausbaustufe 6 – TODO Timer / Fade-Out:
///   In [setTimerOption] einen dart:async Timer starten.
class AudioPlayerService extends ChangeNotifier {
  AudioPlayerService._();

  static final AudioPlayerService instance = AudioPlayerService._();

  final AudioPlayer _player = AudioPlayer();

  PlayerStatus _status = PlayerStatus.stopped;
  HypnosisSession? _currentSession;
  SleepTimerOption? _timerOption;

  PlayerStatus get status => _status;
  HypnosisSession? get currentSession => _currentSession;
  SleepTimerOption? get timerOption => _timerOption;

  bool get isPlaying => _status == PlayerStatus.playing;
  bool get isPaused => _status == PlayerStatus.paused;
  bool get isStopped => _status == PlayerStatus.stopped;

  // ── Öffentliche API ───────────────────────────────────────────────────────

  void setTimerOption(SleepTimerOption option) {
    _timerOption = option;
    debugPrint(
      '[Player] Timer gesetzt: '
      '${option.isUnlimited ? "kein Timer" : "${option.durationMinutes} min"}',
    );
    notifyListeners();
  }

  /// Startet die Wiedergabe einer Session.
  Future<void> play(HypnosisSession session) async {
    if (session.audioPath == null) {
      debugPrint(
        '[Player] Kein audioPath für "${session.title}" '
        '– Wiedergabe übersprungen.',
      );
      // Zustand trotzdem setzen damit UI korrekt reagiert
      _currentSession = session;
      _status = PlayerStatus.playing;
      notifyListeners();
      return;
    }

    try {
      debugPrint('[Player] Lade: ${session.audioPath}');

      if (_currentSession?.id != session.id) {
        await _player.stop();
        await _player.setAsset(session.audioPath!);
        debugPrint('[Player] Asset geladen: ${session.audioPath}');
      }

      _currentSession = session;
      await _player.play();
      _status = PlayerStatus.playing;
      debugPrint('[Player] Wiedergabe gestartet: "${session.title}"');
    } catch (e) {
      debugPrint('[Player] Fehler beim Starten: $e');
      // Fehlerzustand: Session als aktiv markieren aber nicht playing
      _currentSession = session;
      _status = PlayerStatus.stopped;
    }

    notifyListeners();
  }

  Future<void> pause() async {
    try {
      await _player.pause();
      debugPrint('[Player] Pausiert');
    } catch (e) {
      debugPrint('[Player] Fehler beim Pausieren: $e');
    }
    _status = PlayerStatus.paused;
    notifyListeners();
  }

  Future<void> resume() async {
    if (_status != PlayerStatus.paused) return;
    try {
      await _player.play();
      _status = PlayerStatus.playing;
      debugPrint('[Player] Fortgesetzt');
    } catch (e) {
      debugPrint('[Player] Fehler beim Fortsetzen: $e');
    }
    notifyListeners();
  }

  Future<void> stop() async {
    try {
      await _player.stop();
      debugPrint('[Player] Gestoppt');
    } catch (e) {
      debugPrint('[Player] Fehler beim Stoppen: $e');
    }
    _status = PlayerStatus.stopped;
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
