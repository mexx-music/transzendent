import 'package:flutter/material.dart';
import 'package:transcendent_mind/l10n/app_localizations.dart';
import '../../../app/app_theme.dart';
import '../../../core/models/background_sound.dart';
import '../../../features/player/services/audio_player_service.dart';
import '../data/background_sound_repository.dart';

/// Multi-select background sound picker.
/// Reads state from [AudioPlayerService] directly – no props needed.
/// Chips update instantly on tap; audio loads asynchronously in the background.
class BackgroundSoundPicker extends StatelessWidget {
  const BackgroundSoundPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final svc = AudioPlayerService.instance;
    final sounds = BackgroundSoundRepository.sounds;

    return ListenableBuilder(
      listenable: svc,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.surround_sound_rounded,
                  color: AppTheme.primaryLight,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.backgroundSoundTitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryLight,
                    letterSpacing: 0.6,
                  ),
                ),
                if (svc.hasActiveBackground) ...[
                  const Spacer(),
                  Text(
                    '${svc.activeBackgroundCount} aktiv',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.onSurface,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 96,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: sounds.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final sound = sounds[index];
                  final isActive = sound.isSilence
                      ? !svc.hasActiveBackground
                      : svc.isBackgroundActive(sound.id);
                  final isLoading = !sound.isSilence &&
                      svc.isBackgroundLoading(sound.id);
                  return _SoundChip(
                    sound: sound,
                    isSelected: isActive,
                    isLoading: isLoading,
                    onTap: () => svc.toggleBackgroundSound(sound),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SoundChip extends StatelessWidget {
  final BackgroundSound sound;
  final bool isSelected;
  final bool isLoading;
  final VoidCallback onTap;

  const _SoundChip({
    required this.sound,
    required this.isSelected,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 80,
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withValues(alpha: 0.35)
              : AppTheme.surface.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryLight
                : AppTheme.primaryLight.withValues(alpha: 0.18),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon or loading spinner
              SizedBox(
                width: 26,
                height: 26,
                child: isLoading
                    ? Center(
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.primaryLight,
                          ),
                        ),
                      )
                    : Icon(
                        sound.icon,
                        color: isSelected
                            ? AppTheme.primaryLight
                            : AppTheme.onSurface,
                        size: 26,
                      ),
              ),
              const SizedBox(height: 6),
              Text(
                sound.title,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected
                      ? AppTheme.primaryLight
                      : AppTheme.onSurface,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
