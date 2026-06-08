import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../../../core/models/hypnosis_session.dart';
import '../../../core/models/sleep_timer_option.dart';

/// Mögliche Wiedergabe-Zustände.
enum PlayerStatus { stopped, playing, paused }

/// Zentraler Audio-Service – Singleton, ChangeNotifier.
///
/// Verwendung ohne Riverpod / Provider:
///   AudioPlayerService.instance   → Zugriff von überall
///   ListenableBuilder(listenable: AudioPlayerService.instance, ...)
///
/// Ausbaustufe 5 – TODO Hintergrund-Sound:
///   Einen zweiten [AudioPlayer] (_bgPlayer) ergänzen, der unabhängig vom
///   Session-Player läuft. [BackgroundSound.assetPath] wird per
///   _bgPlayer.setAsset(...) geladen und mit einstellbarer Lautstärke
///   geloopt (setLoopMode(LoopMode.all)). Beide Player werden in [dispose]
///   gemeinsam gestoppt.
///
/// Ausbaustufe 6 – TODO Timer / Fade-Out:
///   In [setTimerOption] einen [dart:async Timer] starten:
///     _timer = Timer(Duration(minutes: option.durationMinutes), stop);
///   Für Fade-Out in den letzten 30 Sekunden einen [Timer.periodic] nutzen,
///   der alle 1 s _player.setVolume(v) um einen kleinen Schritt reduziert,
///   bis v == 0, dann stop() aufrufen. Bestehenden Timer in [setTimerOption]
///   und [stop] immer zuerst mit _timer?.cancel() abbrechen.
///
/// Ausbaustufe 7 – TODO Fortschritts-Stream:
///   _player.positionStream und _player.durationStream exponieren, damit
///   eine Fortschrittsanzeige gebaut werden kann.
class AudioPlayerService extends ChangeNotifier {
  AudioPlayerService._();

  /// Globale Instanz – einmal erstellt, für die gesamte App-Laufzeit.
  static final AudioPlayerService instance = AudioPlayerService._();

  final AudioPlayer _player = AudioPlayer();

  // ── Zustand ──────────────────────────────────────────────────────────────

  PlayerStatus _status = PlayerStatus.stopped;
  HypnosisSession? _currentSession;

  /// Aktuell gesetzte Timer-Option – Standard: unbegrenzt (kein Stopp).
  SleepTimerOption? _timerOption;

  PlayerStatus get status => _status;
  HypnosisSession? get currentSession => _currentSession;
  SleepTimerOption? get timerOption => _timerOption;

  bool get isPlaying => _status == PlayerStatus.playing;
  bool get isPaused => _status == PlayerStatus.paused;
  bool get isStopped => _status == PlayerStatus.stopped;

  // ── Öffentliche API ───────────────────────────────────────────────────────

  /// Speichert die gewählte Timer-Option.
  ///
  /// TODO (Ausbaustufe 6):
  ///   - Bestehenden Timer abbrechen: _timer?.cancel()
  ///   - Wenn !option.isUnlimited: neuen Timer starten
  ///   - Fade-Out in den letzten 30 s via Timer.periodic aktivieren
  void setTimerOption(SleepTimerOption option) {
    _timerOption = option;
    debugPrint(
      '[AudioPlayerService] Timer gesetzt: ${option.isUnlimited ? "kein Timer" : "${option.durationMinutes} min"}',
    );
    notifyListeners();
  }

  /// Startet die Wiedergabe einer Session.
  /// Wenn [session.audioPath] null ist, wird graceful abgebrochen.
  Future<void> play(HypnosisSession session) async {
    if (session.audioPath == null) {
      debugPrint(
        '[AudioPlayerService] Kein audioPath für "${session.title}" '
        '– Wiedergabe übersprungen. '
        'Trage den Dateipfad in SessionRepository ein, um Audio zu aktivieren.',
      );
      return;
    }

    // Andere Session: Player zurücksetzen
    if (_currentSession?.id != session.id) {
      await _player.stop();
      await _player.setAsset(session.audioPath!);
    }

    _currentSession = session;
    await _player.play();
    _status = PlayerStatus.playing;
    notifyListeners();
  }

  /// Pausiert die laufende Wiedergabe.
  Future<void> pause() async {
    await _player.pause();
    _status = PlayerStatus.paused;
    notifyListeners();
  }

  /// Setzt eine pausierte Wiedergabe fort.
  Future<void> resume() async {
    if (_status != PlayerStatus.paused) return;
    await _player.play();
    _status = PlayerStatus.playing;
    notifyListeners();
  }

  /// Stoppt die Wiedergabe vollständig.
  ///
  /// TODO (Ausbaustufe 6): _timer?.cancel() vor dem Stop aufrufen.
  Future<void> stop() async {
    await _player.stop();
    _status = PlayerStatus.stopped;
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
