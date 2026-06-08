import 'package:flutter/material.dart';
import 'package:transcendent_mind/l10n/app_localizations.dart';
import 'app_router.dart';
import 'app_theme.dart';

class TranszendentApp extends StatelessWidget {
  const TranszendentApp({super.key});

  static final localeNotifier = ValueNotifier<Locale>(const Locale('de'));

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: localeNotifier,
      builder: (context, locale, _) {
        return MaterialApp(
          title: 'Transzendent',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          initialRoute: AppRouter.home,
          routes: AppRouter.routes,
        );
      },
    );
  }
}
