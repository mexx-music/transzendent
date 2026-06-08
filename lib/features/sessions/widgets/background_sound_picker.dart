import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/models/background_sound.dart';
import '../data/background_sound_repository.dart';

/// Horizontaler Sound-Picker für den [SessionDetailScreen].
///
/// Gibt den ausgewählten [BackgroundSound] per [onChanged] zurück.
/// Standard: Stille.
class BackgroundSoundPicker extends StatelessWidget {
  final BackgroundSound selected;
  final ValueChanged<BackgroundSound> onChanged;

  const BackgroundSoundPicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final sounds = BackgroundSoundRepository.sounds;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ──────────────────────────────────────────────────────
        const Row(
          children: [
            Icon(
              Icons.surround_sound_rounded,
              color: AppTheme.primaryLight,
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              'Hintergrund',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryLight,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ── Horizontale Sound-Karten ─────────────────────────────────────
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: sounds.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final sound = sounds[index];
              final isSelected = sound.id == selected.id;
              return _SoundChip(
                sound: sound,
                isSelected: isSelected,
                onTap: () {
                  // Premium-Sounds: Badge anzeigen, aber auswählen erlauben
                  // (Sperr-Logik kommt in einer späteren Ausbaustufe)
                  onChanged(sound);
                },
              );
            },
          ),
        ),

        // ── Aktuelle Auswahl – Beschreibung ──────────────────────────────
        const SizedBox(height: 10),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: Text(
            selected.isSilence
                ? 'Keine Hintergrundmusik aktiv.'
                : selected.description,
            key: ValueKey(selected.id),
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.onSurface,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Einzelne Sound-Karte ──────────────────────────────────────────────────────

class _SoundChip extends StatelessWidget {
  final BackgroundSound sound;
  final bool isSelected;
  final VoidCallback onTap;

  const _SoundChip({
    required this.sound,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
        child: Stack(
          children: [
            // Icon + Label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    sound.icon,
                    color: isSelected
                        ? AppTheme.primaryLight
                        : AppTheme.onSurface,
                    size: 26,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    sound.title,
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected
                          ? AppTheme.primaryLight
                          : AppTheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Premium-Badge – oben rechts
            if (sound.isPremium)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFB8860B), Color(0xFFFFD700)],
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '★',
                    style: TextStyle(fontSize: 8, color: Colors.black87),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
