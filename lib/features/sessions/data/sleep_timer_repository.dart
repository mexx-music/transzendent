import '../../../core/models/sleep_timer_option.dart';

/// Statisches Repository für Sleep-Timer-Optionen.
///
/// Ausbaustufe 7 – TODO echter Timer:
///   In [AudioPlayerService.setTimerOption] einen [Timer] starten, der
///   nach [option.durationMinutes] Minuten [stop()] aufruft.
///   Für Fade-Out: in den letzten 30 Sekunden schrittweise
///   _player.setVolume(v) reduzieren (z. B. via [Timer.periodic]).
class SleepTimerRepository {
  SleepTimerRepository._();

  static const List<SleepTimerOption> options = [
    SleepTimerOption(
      id: 'unlimited',
      title: 'Ohne Timer',
      durationMinutes: 0,
      isUnlimited: true,
    ),
    SleepTimerOption(id: '10min', title: '10 min', durationMinutes: 10),
    SleepTimerOption(id: '20min', title: '20 min', durationMinutes: 20),
    SleepTimerOption(id: '30min', title: '30 min', durationMinutes: 30),
    SleepTimerOption(id: '45min', title: '45 min', durationMinutes: 45),
    SleepTimerOption(id: '60min', title: '60 min', durationMinutes: 60),
  ];

  /// Standard: kein Timer
  static SleepTimerOption get defaultOption => options.first;

  /// Option anhand der ID finden
  static SleepTimerOption? findById(String id) {
    try {
      return options.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }
}
