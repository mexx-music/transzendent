import 'package:flutter/material.dart';
import 'app_router.dart';
import 'app_theme.dart';

/// Root-Widget der App – hält Theme und Router zusammen.
class TranszendentApp extends StatelessWidget {
  const TranszendentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transzendent',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      initialRoute: AppRouter.home,
      routes: AppRouter.routes,
    );
  }
}
