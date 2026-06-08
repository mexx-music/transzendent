import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/models/hypnosis_session.dart';
import '../../../core/models/session_category.dart';
import '../data/session_repository.dart';
import '../screens/session_detail_screen.dart';
import '../widgets/session_card.dart';

/// Zeigt alle Sessions einer Kategorie als scrollbare Liste.
class SessionListScreen extends StatelessWidget {
  final SessionCategory category;

  const SessionListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final sessions = SessionRepository.sessionsForCategory(category.id);

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
        title: Text(
          category.title,
          style: const TextStyle(
            color: AppTheme.onBackground,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // ── Hintergrundbild (identisch zum Homescreen) ────────────────────
          _Background(),

          // ── Inhalt ────────────────────────────────────────────────────────
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Untertitel der Kategorie
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                  child: Text(
                    category.subtitle,
                    style: const TextStyle(
                      color: AppTheme.onSurface,
                      fontSize: 13,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),

                // Session-Liste
                Expanded(
                  child: sessions.isEmpty
                      ? const _EmptyState()
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                          itemCount: sessions.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            final session = sessions[index];
                            return SessionCard(
                              session: session,
                              onTap: () => _openDetail(context, session),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, HypnosisSession session) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SessionDetailScreen(session: session)),
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Noch keine Sessions in dieser Kategorie.',
        style: TextStyle(color: AppTheme.onSurface),
        textAlign: TextAlign.center,
      ),
    );
  }
}
