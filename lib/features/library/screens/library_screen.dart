import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/models/hypnosis_session.dart';
import '../../../core/widgets/adaptive_background.dart';
import '../../../core/widgets/session_list_tile.dart';
import '../../sessions/data/session_repository.dart';
import '../../sessions/screens/session_detail_screen.dart';
import '../services/library_service.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final double maxWidth = width >= 900 ? 900 : 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Bibliothek',
          style: TextStyle(
            color: AppTheme.onBackground,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: AdaptiveBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: ListenableBuilder(
                listenable: LibraryService.instance,
                builder: (context, _) {
                  final svc = LibraryService.instance;
                  final favorites = _resolveSessions(svc.favoriteSessionIds);
                  final recent = _resolveSessions(svc.recentSessionIds);
                  final isEmpty = favorites.isEmpty && recent.isEmpty;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
                    child: isEmpty
                        ? const _EmptyLibrary()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (favorites.isNotEmpty) ...[
                                _SectionHeader(
                                  icon: Icons.favorite_rounded,
                                  title: 'Favoriten',
                                ),
                                const SizedBox(height: 12),
                                _SessionList(
                                  sessions: favorites,
                                  onTap: (s) => _openDetail(context, s),
                                ),
                                const SizedBox(height: 28),
                              ],
                              if (recent.isNotEmpty) ...[
                                _SectionHeader(
                                  icon: Icons.history_rounded,
                                  title: 'Zuletzt gehört',
                                ),
                                const SizedBox(height: 12),
                                _SessionList(
                                  sessions: recent,
                                  onTap: (s) => _openDetail(context, s),
                                ),
                              ],
                            ],
                          ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<HypnosisSession> _resolveSessions(Iterable<String> ids) =>
      ids.map(SessionRepository.findById).whereType<HypnosisSession>().toList();

  void _openDetail(BuildContext context, HypnosisSession session) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SessionDetailScreen(session: session)),
    );
  }
}

// ── Private Widgets ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryLight, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppTheme.onBackground,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}

class _SessionList extends StatelessWidget {
  final List<HypnosisSession> sessions;
  final void Function(HypnosisSession) onTap;
  const _SessionList({required this.sessions, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: sessions
          .map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SessionListTile(session: s, onTap: () => onTap(s)),
            ),
          )
          .toList(),
    );
  }
}

class _EmptyLibrary extends StatelessWidget {
  const _EmptyLibrary();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Icon(
            Icons.library_music_outlined,
            size: 64,
            color: AppTheme.primaryLight,
          ),
          SizedBox(height: 20),
          Text(
            'Noch keine Einträge',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.onBackground,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Starte eine Session oder markiere\nSessions als Favoriten.',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.onSurface,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
