import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/models/background_sound.dart';
import '../../../core/models/hypnosis_session.dart';
import '../../../core/models/sleep_timer_option.dart';
import '../../../core/widgets/adaptive_background.dart';
import '../../../core/widgets/glass_card.dart';
import '../../library/services/library_service.dart';
import '../../player/services/audio_player_service.dart';
import '../data/background_sound_repository.dart';
import '../data/sleep_timer_repository.dart';
import '../data/suggestion_repository.dart';
import '../widgets/background_sound_picker.dart';
import '../widgets/sleep_timer_picker.dart';
import '../widgets/suggestion_section.dart';

class SessionDetailScreen extends StatefulWidget {
  final HypnosisSession session;

  const SessionDetailScreen({super.key, required this.session});

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  late BackgroundSound _selectedSound;
  late SleepTimerOption _selectedTimer;

  @override
  void initState() {
    super.initState();
    _selectedSound = BackgroundSoundRepository.silence;
    _selectedTimer = SleepTimerRepository.defaultOption;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;
    final double maxWidth = isTablet ? 900.0 : 600.0;
    final double coverSize = isTablet ? 240.0 : 180.0;
    final double topSpacing = isTablet ? 32.0 : 20.0;
    final double afterCoverSpacing = isTablet ? 40.0 : 32.0;

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
          ListenableBuilder(
            listenable: LibraryService.instance,
            builder: (_, __) {
              final isFav =
                  LibraryService.instance.isFavorite(widget.session.id);
              return IconButton(
                icon: Icon(
                  isFav
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color:
                      isFav ? const Color(0xFFE040FB) : AppTheme.onBackground,
                ),
                onPressed: () => LibraryService.instance
                    .toggleFavorite(widget.session.id),
                tooltip: isFav
                    ? 'Aus Favoriten entfernen'
                    : 'Zu Favoriten hinzufügen',
              );
            },
          ),
        ],
      ),
      body: AdaptiveBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: topSpacing),

                    _CoverArt(
                        isPremium: widget.session.isPremium, size: coverSize),
                    SizedBox(height: afterCoverSpacing),

                    Text(
                      widget.session.title,
                      style: TextStyle(
                        fontSize: isTablet ? 28.0 : 24.0,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onBackground,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    Text(
                      '${widget.session.durationMinutes} Minuten',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.primaryLight,
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(height: isTablet ? 36.0 : 28.0),

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

                    if (script != null) ...[
                      SuggestionSection(script: script),
                      const SizedBox(height: 24),
                    ],

                    GlassCard(
                      padding: const EdgeInsets.all(20),
                      child: BackgroundSoundPicker(
                        selected: _selectedSound,
                        onChanged: (sound) =>
                            setState(() => _selectedSound = sound),
                      ),
                    ),
                    const SizedBox(height: 16),

                    GlassCard(
                      padding: const EdgeInsets.all(20),
                      child: SleepTimerPicker(
                        selected: _selectedTimer,
                        onChanged: (option) {
                          setState(() => _selectedTimer = option);
                          AudioPlayerService.instance.setTimerOption(option);
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    _PlayerControls(session: widget.session),
                    const SizedBox(height: 16),

                    if (widget.session.isPremium)
                      const Text(
                        'Diese Session ist Teil des Premium-Bereichs.',
                        style:
                            TextStyle(fontSize: 12, color: AppTheme.onSurface),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Private Widgets ───────────────────────────────────────────────────────────

class _CoverArt extends StatelessWidget {
  final bool isPremium;
  final double size;
  const _CoverArt({required this.isPremium, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
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
      child: Icon(
        Icons.self_improvement_rounded,
        size: size * 0.4,
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
            GestureDetector(
              onTap: () async {
                if (isPlaying) {
                  await svc.pause();
                } else if (isPaused) {
                  await svc.resume();
                } else {
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
                      Icon(Icons.stop_rounded,
                          color: AppTheme.onSurface, size: 20),
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
