import 'package:flutter/material.dart';
import 'package:transcendent_mind/l10n/app_localizations.dart';
import '../../../app/app_theme.dart';
import '../../../core/models/suggestion_script.dart';
import '../../../core/widgets/glass_card.dart';
import '../screens/script_preview_screen.dart';

class SuggestionSection extends StatelessWidget {
  final SuggestionScript script;

  const SuggestionSection({super.key, required this.script});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: AppTheme.primaryLight,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.suggestionTitle,
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

          Text(
            script.introText,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.onSurface,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 14),

          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: script.suggestionWords
                .map((word) => _Chip(label: word))
                .toList(),
          ),
          const SizedBox(height: 18),

          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ScriptPreviewScreen(script: script),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryLight.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.article_outlined,
                    color: AppTheme.primaryLight,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.suggestionViewText,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.primaryLight,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
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

class _Chip extends StatelessWidget {
  final String label;
  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryLight.withValues(alpha: 0.28),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: AppTheme.primaryLight,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
