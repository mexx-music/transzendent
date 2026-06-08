/// Modell für eine Sleep-Timer-Option.
class SleepTimerOption {
  final String id;
  final String title;

  /// Dauer in Minuten – bei [isUnlimited] ignoriert
  final int durationMinutes;

  /// true → kein automatischer Stopp
  final bool isUnlimited;

  const SleepTimerOption({
    required this.id,
    required this.title,
    required this.durationMinutes,
    this.isUnlimited = false,
  });
}
