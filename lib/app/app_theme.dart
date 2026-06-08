import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Zentrale Theme-Definition.
/// Dunkel, mystisch – violett/blau Palette.
class AppTheme {
  AppTheme._();

  // ── Farben ────────────────────────────────────────────────────────────────
  static const Color background = Color(0xFF0D0B1E);
  static const Color surface = Color(0xFF1A1733);
  static const Color primary = Color(0xFF7C5CBF);
  static const Color primaryLight = Color(0xFFAA84E8);
  static const Color accent = Color(0xFF4FC3F7);
  static const Color onBackground = Color(0xFFE8E0F5);
  static const Color onSurface = Color(0xFFCBC4E0);
  static const Color divider = Color(0xFF2E2A4A);

  // ── Theme ─────────────────────────────────────────────────────────────────
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: accent,
      surface: surface,
      onPrimary: Colors.white,
      onSurface: onSurface,
    ),
    textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme).copyWith(
      displaySmall: GoogleFonts.cinzel(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: onBackground,
        letterSpacing: 2,
      ),
      titleMedium: GoogleFonts.lato(
        fontSize: 14,
        color: onSurface,
        letterSpacing: 1.2,
      ),
    ),
    dividerColor: divider,
    useMaterial3: true,
  );
}
