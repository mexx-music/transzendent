import 'package:flutter/material.dart';
import 'package:transcendent_mind/l10n/app_localizations.dart';
import '../../../app/app_theme.dart';
import '../../../core/models/sleep_timer_option.dart';
import '../data/sleep_timer_repository.dart';

class SleepTimerPicker extends StatelessWidget {
  final SleepTimerOption selected;
  final ValueChanged<SleepTimerOption> onChanged;

  const SleepTimerPicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final options = SleepTimerRepository.options;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.bedtime_rounded,
                color: AppTheme.primaryLight, size: 18),
            const SizedBox(width: 8),
            Text(
              l10n.timerTitle,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryLight,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options
              .map(
                (option) => _TimerChip(
                  option: option,
                  isSelected: option.id == selected.id,
                  onTap: () => onChanged(option),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 10),

        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: Text(
            selected.isUnlimited
                ? l10n.timerUnlimited
                : l10n.timerAutoStop(selected.durationMinutes),
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

class _TimerChip extends StatelessWidget {
  final SleepTimerOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimerChip({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withValues(alpha: 0.35)
              : AppTheme.surface.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryLight
                : AppTheme.primaryLight.withValues(alpha: 0.18),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          option.title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? AppTheme.primaryLight : AppTheme.onSurface,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
