import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/models/hypnosis_session.dart';
import '../../../core/widgets/glass_card.dart';
import '../../features/library/services/library_service.dart';

/// Kompakte Session-Karte für Library und Homescreen-Abschnitte.
/// Zeigt Titel, Dauer und Favoriten-Herzchen.
class SessionListTile extends StatelessWidget {
  final HypnosisSession session;
  final VoidCallback onTap;

  const SessionListTile({
    super.key,
    required this.session,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Dauer-Kreis
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, Color(0xFF4A3080)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${session.durationMinutes}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'min',
                    style: TextStyle(fontSize: 8, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // Titel
            Expanded(
              child: Text(
                session.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.onBackground,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Favoriten-Icon – reaktiv
            ListenableBuilder(
              listenable: LibraryService.instance,
              builder: (_, __) {
                final isFav = LibraryService.instance.isFavorite(session.id);
                return Icon(
                  isFav
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isFav ? const Color(0xFFE040FB) : AppTheme.onSurface,
                  size: 20,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
