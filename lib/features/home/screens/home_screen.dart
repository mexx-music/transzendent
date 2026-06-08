import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/models/hypnosis_session.dart';
import '../../../core/widgets/session_list_tile.dart';
import '../../../features/library/screens/library_screen.dart';
import '../../../features/library/services/library_service.dart';
import '../../../features/sessions/data/session_repository.dart';
import '../../../features/sessions/screens/session_detail_screen.dart';
import '../widgets/category_card.dart';
import '../widgets/mini_player_bar.dart';

/// Startscreen der App.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = SessionRepository.categories;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ── Hintergrundbild ─────────────────────────────────────────────
          _Background(),

          // ── Hauptinhalt ──────────────────────────────────────────────────
          SafeArea(
            child: ListenableBuilder(
              listenable: LibraryService.instance,
              builder: (context, _) {
                final svc = LibraryService.instance;

                final recent = svc.recentSessionIds
                    .map(SessionRepository.findById)
                    .whereType<HypnosisSession>()
                    .take(3)
                    .toList();

                final favorites = svc.favoriteSessionIds
                    .map(SessionRepository.findById)
                    .whereType<HypnosisSession>()
                    .take(3)
                    .toList();

                return CustomScrollView(
                  slivers: [
                    // Abstand + Header
                    const SliverToBoxAdapter(child: SizedBox(height: 32)),
                    SliverToBoxAdapter(child: _Header()),
                    const SliverToBoxAdapter(child: SizedBox(height: 28)),

                    // ── Zuletzt gehört ─────────────────────────────────────
                    if (recent.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: _HomeSectionHeader(
                          icon: Icons.history_rounded,
                          title: 'Zuletzt gehört',
                          onSeeAll: () => _openLibrary(context),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (_, i) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: SessionListTile(
                                session: recent[i],
                                onTap: () => _openDetail(context, recent[i]),
                              ),
                            ),
                            childCount: recent.length,
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    ],

                    // ── Favoriten ──────────────────────────────────────────
                    if (favorites.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: _HomeSectionHeader(
                          icon: Icons.favorite_rounded,
                          title: 'Favoriten',
                          onSeeAll: () => _openLibrary(context),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (_, i) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: SessionListTile(
                                session: favorites[i],
                                onTap: () => _openDetail(context, favorites[i]),
                              ),
                            ),
                            childCount: favorites.length,
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    ],

                    // ── Kategorien ─────────────────────────────────────────
                    SliverToBoxAdapter(
                      child: _HomeSectionHeader(
                        icon: Icons.apps_rounded,
                        title: 'Kategorien',
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 10, 24, 80),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: CategoryCard(category: categories[i]),
                          ),
                          childCount: categories.length,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // ── Mini-Player unten ────────────────────────────────────────────
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: MiniPlayerBar(),
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

  void _openLibrary(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const LibraryScreen()));
  }
}

// ── Private Widgets ──────────────────────────────────────────────────────────

class _HomeSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onSeeAll;

  const _HomeSectionHeader({
    required this.icon,
    required this.title,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryLight, size: 16),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.onBackground,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: const Text(
                'Alle anzeigen',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.primaryLight,
                  letterSpacing: 0.3,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Image.asset(
        AppConstants.backgroundImage,
        fit: BoxFit.cover,
        // Fallback-Farbe, falls das Bild noch nicht vorhanden ist
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

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          AppConstants.appName.toUpperCase(),
          style: tt.displaySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          AppConstants.appTagline,
          style: tt.titleMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
