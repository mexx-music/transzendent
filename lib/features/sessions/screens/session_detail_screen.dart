import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/models/background_sound.dart';
import '../../../core/models/hypnosis_session.dart';
import '../../../core/models/sleep_timer_option.dart';
import '../../../core/widgets/glass_card.dart';
import '../../library/services/library_service.dart';
import '../../player/services/audio_player_service.dart';
import '../data/background_sound_repository.dart';
import '../data/sleep_timer_repository.dart';
import '../data/suggestion_repository.dart';
import '../widgets/background_sound_picker.dart';
import '../widgets/sleep_timer_picker.dart';
import '../widgets/suggestion_section.dart';

/// Detailseite einer Session.
class SessionDetailScreen extends StatefulWidget {
  final HypnosisSession session;

  const SessionDetailScreen({super.key, required this.session});

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  // Ausgewählter Hintergrund-Sound – Standard: Stille
  late BackgroundSound _selectedSound;

  // Gewählte Timer-Option – Standard: kein Timer
  late SleepTimerOption _selectedTimer;

  @override
  void initState() {
    super.initState();
    _selectedSound = BackgroundSoundRepository.silence;
    _selectedTimer = SleepTimerRepository.defaultOption;
  }

  @override
  Widget build(BuildContext context) {
    // Script für diese Session – kann null sein wenn noch keins angelegt
    final script = SuggestionRepository.forSession(widget.session.id);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppTheme.onBackground,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // Favoriten-Button – reagiert auf LibraryService
          ListenableBuilder(
            listenable: LibraryService.instance,
            builder: (_, __) {
              final isFav = LibraryService.instance.isFavorite(
                widget.session.id,
              );
              return IconButton(
                icon: Icon(
                  isFav
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isFav
                      ? const Color(0xFFE040FB)
                      : AppTheme.onBackground,
                ),
                onPressed: () =>
                    LibraryService.instance.toggleFavorite(widget.session.id),
                tooltip: isFav
                    ? 'Aus Favoriten entfernen'
                    : 'Zu Favoriten hinzufügen',
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // ── Hintergrundbild ────────────────────────────────────────────────
          _Background(),

          // ── Inhalt ─────────────────────────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Cover-Platzhalter
                  _CoverArt(isPremium: widget.session.isPremium),
                  const SizedBox(height: 32),

                  // Titel
                  Text(
                    widget.session.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onBackground,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Dauer
                  Text(
                    '${widget.session.durationMinutes} Minuten',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.primaryLight,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Beschreibung
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      widget.session.description,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppTheme.onSurface,
                        height: 1.65,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Suggestion-Abschnitt – nur anzeigen wenn ein Script existiert
                  if (script != null) ...[
                    SuggestionSection(script: script),
                    const SizedBox(height: 24),
                  ],

                  // ── Hintergrund-Sound-Auswahl ────────────────────────────
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: BackgroundSoundPicker(
                      selected: _selectedSound,
                      onChanged: (sound) =>
                          setState(() => _selectedSound = sound),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Timer-Auswahl ─────────────────────────────────────────
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: SleepTimerPicker(
                      selected: _selectedTimer,
                      onChanged: (option) {
                        setState(() => _selectedTimer = option);
                        // Timer-Option an Service weitergeben
                        AudioPlayerService.instance.setTimerOption(option);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Player-Steuerung – reagiert auf AudioPlayerService
                  _PlayerControls(session: widget.session),
                  const SizedBox(height: 16),

                  if (widget.session.isPremium)
                    const Text(
                      'Diese Session ist Teil des Premium-Bereichs.',
                      style: TextStyle(fontSize: 12, color: AppTheme.onSurface),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Private Widgets ───────────────────────────────────────────────────────────

class _Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Image.asset(
        AppConstants.backgroundImage,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.4),
              radius: 1.2,
              colors: [Color(0xFF2D1B69), Color(0xFF0D0B1E)],
            ),
          ),
        ),
      ),
    );
  }
}

class _CoverArt extends StatelessWidget {
  final bool isPremium;
  const _CoverArt({required this.isPremium});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: isPremium
              ? const [Color(0xFFB8860B), Color(0xFF4A3080)]
              : const [AppTheme.primary, Color(0xFF1A1050)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.45),
            blurRadius: 48,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: const Icon(
        Icons.self_improvement_rounded,
        size: 72,
        color: Colors.white54,
      ),
    );
  }
}

class _PlayerControls extends StatelessWidget {
  final HypnosisSession session;
  const _PlayerControls({required this.session});

  @override
  Widget build(BuildContext context) {
    final svc = AudioPlayerService.instance;

    return ListenableBuilder(
      listenable: svc,
      builder: (context, _) {
        final isThisSession = svc.currentSession?.id == session.id;
        final isPlaying = isThisSession && svc.isPlaying;
        final isPaused = isThisSession && svc.isPaused;

        return Column(
          children: [
            // ── Haupt-Button ──────────────────────────────────────────────
            GestureDetector(
              onTap: () async {
                if (isPlaying) {
                  await svc.pause();
                } else if (isPaused) {
                  await svc.resume();
                } else {
                  // Session als kürzlich gespielt markieren
                  LibraryService.instance.markRecentlyPlayed(session.id);
                  await svc.play(session);
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, Color(0xFF4A3080)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isPlaying
                          ? Icons.pause_rounded
                          : isPaused
                          ? Icons.play_arrow_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      isPlaying
                          ? 'Pausieren'
                          : isPaused
                          ? 'Fortsetzen'
                          : 'Session starten',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Stop-Button – nur sichtbar wenn diese Session aktiv ist ───
            if (isPlaying || isPaused) ...[
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async => svc.stop(),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.surface.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.primaryLight.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.stop_rounded,
                        color: AppTheme.onSurface,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Stoppen',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.onSurface,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // ── Hinweis wenn kein Audio hinterlegt ────────────────────────
            if (session.audioPath == null) ...[
              const SizedBox(height: 10),
              const Text(
                'Noch keine Audiodatei hinterlegt.',
                style: TextStyle(fontSize: 11, color: AppTheme.onSurface),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        );
      },
    );
  }
}
