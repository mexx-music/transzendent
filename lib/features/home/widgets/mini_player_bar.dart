import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../player/services/audio_player_service.dart';

/// Mini-Player-Leiste am unteren Bildschirmrand.
/// Lauscht auf [AudioPlayerService.instance] und zeigt den aktuellen Zustand.
class MiniPlayerBar extends StatelessWidget {
  const MiniPlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AudioPlayerService.instance,
      builder: (context, _) {
        final svc = AudioPlayerService.instance;
        final session = svc.currentSession;
        final hasSession = session != null && !svc.isStopped;

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          decoration: BoxDecoration(
            color: AppTheme.surface.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppTheme.primaryLight.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // ── Cover-Icon ────────────────────────────────────────────────
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: hasSession
                        ? const [AppTheme.primary, Color(0xFF2D1B69)]
                        : const [Color(0xFF2A2450), Color(0xFF1A1733)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  hasSession
                      ? Icons.self_improvement_rounded
                      : Icons.music_note_rounded,
                  color: hasSession ? Colors.white70 : Colors.white30,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),

              // ── Titel & Untertitel ────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      hasSession ? session.title : 'Kein Titel aktiv',
                      style: const TextStyle(
                        color: AppTheme.onBackground,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hasSession
                          ? _statusLabel(svc.status)
                          : 'Wähle eine Session aus',
                      style: const TextStyle(
                        color: AppTheme.onSurface,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Stop-Button ───────────────────────────────────────────────
              if (hasSession)
                IconButton(
                  icon: const Icon(
                    Icons.stop_rounded,
                    color: AppTheme.onSurface,
                    size: 24,
                  ),
                  onPressed: () async => AudioPlayerService.instance.stop(),
                  tooltip: 'Stoppen',
                ),

              // ── Play / Pause ──────────────────────────────────────────────
              IconButton(
                icon: Icon(
                  svc.isPlaying
                      ? Icons.pause_circle_filled_rounded
                      : Icons.play_circle_fill_rounded,
                  color: hasSession
                      ? AppTheme.primaryLight
                      : AppTheme.primaryLight.withValues(alpha: 0.35),
                  size: 36,
                ),
                onPressed: hasSession
                    ? () async {
                        if (svc.isPlaying) {
                          await svc.pause();
                        } else {
                          await svc.resume();
                        }
                      }
                    : null,
                tooltip: svc.isPlaying ? 'Pause' : 'Fortsetzen',
              ),
            ],
          ),
        );
      },
    );
  }

  String _statusLabel(PlayerStatus status) => switch (status) {
    PlayerStatus.playing => 'Wird abgespielt …',
    PlayerStatus.paused => 'Pausiert',
    PlayerStatus.stopped => 'Gestoppt',
  };
}
