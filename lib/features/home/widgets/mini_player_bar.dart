import 'package:flutter/material.dart';
import 'package:transcendent_mind/l10n/app_localizations.dart';
import '../../../app/app_theme.dart';
import '../../player/services/audio_player_service.dart';
import '../../sessions/data/background_sound_repository.dart';

class MiniPlayerBar extends StatelessWidget {
  const MiniPlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: AudioPlayerService.instance,
      builder: (context, _) {
        final svc = AudioPlayerService.instance;
        final session = svc.currentSession;
        final hasSession = session != null && !svc.isStopped;

        final String statusLabel = switch (svc.status) {
          PlayerStatus.playing => l10n.playerPlaying,
          PlayerStatus.paused => l10n.playerPaused,
          PlayerStatus.stopped => l10n.playerStopped,
        };

        final String subtitle = _buildSubtitle(svc, statusLabel, l10n);

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
                      hasSession ? session.title : l10n.playerNoTitle,
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
                      hasSession ? subtitle : l10n.playerChooseSession,
                      style: const TextStyle(
                        color: AppTheme.onSurface,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                  tooltip: l10n.playerStop,
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
                tooltip: svc.isPlaying ? l10n.playerPause : l10n.playerResume,
              ),
            ],
          ),
        );
      },
    );
  }

  String _buildSubtitle(
    AudioPlayerService svc,
    String statusLabel,
    AppLocalizations l10n,
  ) {
    if (!svc.hasActiveBackground) return statusLabel;

    if (svc.activeBackgroundCount == 1) {
      final title =
          BackgroundSoundRepository.findById(svc.activeBackgroundSoundIds.first)
              ?.title;
      return title != null ? '$statusLabel · $title' : statusLabel;
    }

    return '$statusLabel · ${l10n.backgroundCountActive(svc.activeBackgroundCount)}';
  }
}
