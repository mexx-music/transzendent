import 'package:flutter/material.dart';
import '../features/home/screens/home_screen.dart';
import '../features/library/screens/library_screen.dart';
import '../features/settings/screens/settings_screen.dart';

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
    settings: (_) => const SettingsScreen(),
  };
}
