import 'package:flutter/material.dart';
import 'package:transcendent_mind/l10n/app_localizations.dart';
import '../../../app/app_router.dart';
import '../../../app/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/models/hypnosis_session.dart';
import '../../../core/widgets/adaptive_background.dart';
import '../../../core/widgets/session_list_tile.dart';
import '../../../features/library/screens/library_screen.dart';
import '../../../features/library/services/library_service.dart';
import '../../../features/sessions/data/session_repository.dart';
import '../../../features/sessions/screens/session_detail_screen.dart';
import '../widgets/category_card.dart';
import '../widgets/mini_player_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final width = MediaQuery.of(context).size.width;
    final double maxWidth = width >= 1100 ? 1100 : width >= 900 ? 900 : 600;
    final categories = SessionRepository.categories;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: AdaptiveBackground(
        child: Stack(
          children: [
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
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
                          const SliverToBoxAdapter(child: SizedBox(height: 32)),
                          SliverToBoxAdapter(child: _Header()),
                          const SliverToBoxAdapter(child: SizedBox(height: 28)),

                          // ── Zuletzt gehört ───────────────────────────────
                          if (recent.isNotEmpty) ...[
                            SliverToBoxAdapter(
                              child: _HomeSectionHeader(
                                icon: Icons.history_rounded,
                                title: l10n.sectionRecentlyPlayed,
                                onSeeAll: () => _openLibrary(context),
                              ),
                            ),
                            SliverPadding(
                              padding:
                                  const EdgeInsets.fromLTRB(24, 10, 24, 0),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (_, i) => Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10),
                                    child: SessionListTile(
                                      session: recent[i],
                                      onTap: () =>
                                          _openDetail(context, recent[i]),
                                    ),
                                  ),
                                  childCount: recent.length,
                                ),
                              ),
                            ),
                            const SliverToBoxAdapter(
                                child: SizedBox(height: 20)),
                          ],

                          // ── Favoriten ────────────────────────────────────
                          if (favorites.isNotEmpty) ...[
                            SliverToBoxAdapter(
                              child: _HomeSectionHeader(
                                icon: Icons.favorite_rounded,
                                title: l10n.sectionFavorites,
                                onSeeAll: () => _openLibrary(context),
                              ),
                            ),
                            SliverPadding(
                              padding:
                                  const EdgeInsets.fromLTRB(24, 10, 24, 0),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (_, i) => Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10),
                                    child: SessionListTile(
                                      session: favorites[i],
                                      onTap: () =>
                                          _openDetail(context, favorites[i]),
                                    ),
                                  ),
                                  childCount: favorites.length,
                                ),
                              ),
                            ),
                            const SliverToBoxAdapter(
                                child: SizedBox(height: 20)),
                          ],

                          // ── Kategorien (responsives Grid) ─────────────────
                          SliverToBoxAdapter(
                            child: _HomeSectionHeader(
                              icon: Icons.apps_rounded,
                              title: l10n.sectionCategories,
                            ),
                          ),
                          SliverPadding(
                            padding:
                                const EdgeInsets.fromLTRB(24, 10, 24, 80),
                            sliver: SliverToBoxAdapter(
                              child: LayoutBuilder(
                                builder: (ctx, constraints) {
                                  final availableWidth = constraints.maxWidth;
                                  final int cols = availableWidth >= 900
                                      ? 3
                                      : availableWidth >= 600
                                          ? 2
                                          : 1;

                                  if (cols == 1) {
                                    return Column(
                                      children: categories
                                          .map(
                                            (cat) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 16),
                                              child:
                                                  CategoryCard(category: cat),
                                            ),
                                          )
                                          .toList(),
                                    );
                                  }

                                  final itemWidth =
                                      (availableWidth - 16.0 * (cols - 1)) /
                                          cols;
                                  return Wrap(
                                    spacing: 16,
                                    runSpacing: 16,
                                    children: categories
                                        .map(
                                          (cat) => SizedBox(
                                            width: itemWidth,
                                            child: CategoryCard(category: cat),
                                          ),
                                        )
                                        .toList(),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),

            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: MiniPlayerBar(),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, HypnosisSession session) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SessionDetailScreen(session: session)),
    );
  }

  void _openLibrary(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const LibraryScreen()));
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
    final l10n = AppLocalizations.of(context);
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
              child: Text(
                l10n.showAll,
                style: const TextStyle(
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

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tt = Theme.of(context).textTheme;
    return Stack(
      children: [
        Column(
          children: [
            Text(
              AppConstants.appName.toUpperCase(),
              style: tt.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.appTagline,
              style: tt.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Positioned(
          top: 0,
          right: 16,
          child: IconButton(
            icon: const Icon(
              Icons.settings_rounded,
              color: AppTheme.onSurface,
              size: 22,
            ),
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRouter.settings),
            tooltip: l10n.settingsTitle,
          ),
        ),
      ],
    );
  }
}
