import 'package:flutter/material.dart';
import '../features/home/screens/home_screen.dart';
import '../features/library/screens/library_screen.dart';

/// Zentrale Route-Definition.
/// Sessions werden per Navigator.push mit Argument übergeben (kein Named-Route),
/// da sie kontextabhängige Daten (SessionCategory) benötigen.
class AppRouter {
  AppRouter._();

  static const String home = '/';
  static const String sessions = '/sessions';
  static const String player = '/player';
  static const String library = '/library';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes => {
    home: (_) => const HomeScreen(),
    library: (_) => const LibraryScreen(),
    // sessions, player, settings: werden per Navigator.push
    // mit Daten-Argumenten aufgerufen – keine Named-Route nötig.
  };
}
