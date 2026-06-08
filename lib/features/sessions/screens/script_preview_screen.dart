import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/models/suggestion_script.dart';
import '../../../core/widgets/glass_card.dart';

/// Zeigt den vollständigen gesprochenen Text eines [SuggestionScript].
class ScriptPreviewScreen extends StatelessWidget {
  final SuggestionScript script;

  const ScriptPreviewScreen({super.key, required this.script});

  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          'Suggestions-Text',
          style: TextStyle(
            color: AppTheme.onBackground,
            fontSize: 17,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // ── Hintergrundbild ──────────────────────────────────────────────
          _Background(),

          // ── Inhalt ───────────────────────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titel
                  Text(
                    script.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onBackground,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Dauer
                  Text(
                    '${script.durationMinutes} Minuten',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryLight,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Einleitung
                  GlassCard(
                    padding: const EdgeInsets.all(18),
                    child: Text(
                      script.introText,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.onSurface,
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Schlüsselwörter
                  const Text(
                    'Themen dieser Session',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.onSurface,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: script.suggestionWords
                        .map((word) => _SuggestionChip(label: word))
                        .toList(),
                  ),
                  const SizedBox(height: 28),

                  // Divider
                  Divider(color: AppTheme.divider, thickness: 1),
                  const SizedBox(height: 20),

                  // Gesprochener Text
                  const Text(
                    'Gesprochener Text',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.onSurface,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      script.spokenScript,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppTheme.onBackground,
                        height: 1.85,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Sicherheitshinweis
                  _SafetyNote(note: script.safetyNote),
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

class _SuggestionChip extends StatelessWidget {
  final String label;
  const _SuggestionChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryLight.withValues(alpha: 0.35),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: AppTheme.primaryLight,
          letterSpacing: 0.4,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _SafetyNote extends StatelessWidget {
  final String note;
  const _SafetyNote({required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: AppTheme.onSurface,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              note,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.onSurface,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
