import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/models/session_category.dart';
import '../../../core/widgets/glass_card.dart';
import '../../sessions/screens/session_list_screen.dart';

/// Große Kategorie-Karte auf dem Homescreen.
class CategoryCard extends StatelessWidget {
  final SessionCategory category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SessionListScreen(category: category),
          ),
        );
      },
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Row(
          children: [
            // Icon-Platzhalter
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.45),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.self_improvement_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 20),

            // Texte
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onBackground,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.onSurface,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.primaryLight,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
