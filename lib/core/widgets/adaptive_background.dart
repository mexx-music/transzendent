import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Vollbildhintergrund der sich an Gerät und Ausrichtung anpasst.
///
/// Bildauswahl:
///   – Desktop / Tablet Querformat  → bgTabletLandscape
///   – Phone Querformat             → bgPhoneLandscape
///   – Portrait (Phone + Tablet)    → bgPhonePortrait
///
/// Darüber liegen ein dunkler Overlay und ein mystischer Verlauf.
class AdaptiveBackground extends StatelessWidget {
  final Widget child;

  const AdaptiveBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    final isTablet = size.shortestSide >= 600;
    final isDesktop = size.width >= 900;

    final String imagePath;
    if (isDesktop || (isTablet && isLandscape)) {
      imagePath = AppConstants.bgTabletLandscape;
    } else if (isLandscape) {
      imagePath = AppConstants.bgPhoneLandscape;
    } else {
      imagePath = AppConstants.bgPhonePortrait;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Hintergrundbild
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const _FallbackGradient(),
        ),

        // Dunkler Overlay (0.35 Opacity → 0x59)
        const ColoredBox(color: Color(0x59000000), child: SizedBox.expand()),

        // Mystischer Verlauf: transparent oben → dunkel unten (0.75 → 0xBF)
        const SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.5, 1.0],
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Color(0xBF12091F),
                ],
              ),
            ),
          ),
        ),

        child,
      ],
    );
  }
}

class _FallbackGradient extends StatelessWidget {
  const _FallbackGradient();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.4),
          radius: 1.2,
          colors: [Color(0xFF2D1B69), Color(0xFF0D0B1E)],
        ),
      ),
    );
  }
}
