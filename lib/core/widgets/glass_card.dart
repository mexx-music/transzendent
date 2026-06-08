import 'package:flutter/material.dart';
import '../../app/app_theme.dart';

/// Halbtransparente Glas-Karte – wiederverwendbar in der gesamten App.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: AppTheme.primaryLight.withValues(alpha: 0.18),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: padding ?? const EdgeInsets.all(20),
      child: child,
    );
  }
}
