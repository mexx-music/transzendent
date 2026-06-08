import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/models/hypnosis_session.dart';
import '../../../core/widgets/glass_card.dart';

/// Karte für eine einzelne Session in der Listen-Ansicht.
class SessionCard extends StatelessWidget {
  final HypnosisSession session;
  final VoidCallback onTap;

  const SessionCard({super.key, required this.session, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Dauer-Badge
            _DurationBadge(minutes: session.durationMinutes),
            const SizedBox(width: 16),

            // Titel & Beschreibung
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          session.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.onBackground,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      if (session.isPremium) const _PremiumBadge(),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    session.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.onSurface,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.primaryLight,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private Hilfs-Widgets ─────────────────────────────────────────────────────

class _DurationBadge extends StatelessWidget {
  final int minutes;
  const _DurationBadge({required this.minutes});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppTheme.primary, Color(0xFF4A3080)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$minutes',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const Text(
            'min',
            style: TextStyle(fontSize: 9, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _PremiumBadge extends StatelessWidget {
  const _PremiumBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFB8860B), Color(0xFFFFD700)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Premium',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
