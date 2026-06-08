import 'package:flutter/material.dart';
import 'package:transcendent_mind/l10n/app_localizations.dart';
import '../../../app/app_theme.dart';
import '../../../app/transzendent_app.dart';
import '../../../core/widgets/adaptive_background.dart';
import '../../../core/widgets/glass_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final width = MediaQuery.of(context).size.width;
    final double maxWidth = width >= 900 ? 900 : 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppTheme.onBackground,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.settingsTitle,
          style: const TextStyle(
            color: AppTheme.onBackground,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: AdaptiveBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _SectionHeader(title: l10n.settingsLanguage),
                    const SizedBox(height: 12),
                    _LanguagePicker(l10n: l10n),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppTheme.primaryLight,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _LanguagePicker extends StatelessWidget {
  final AppLocalizations l10n;
  const _LanguagePicker({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: TranszendentApp.localeNotifier,
      builder: (context, currentLocale, _) {
        return GlassCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _LanguageTile(
                label: l10n.settingsLanguageDe,
                locale: const Locale('de'),
                currentLocale: currentLocale,
              ),
              Divider(
                height: 1,
                color: AppTheme.divider.withValues(alpha: 0.5),
              ),
              _LanguageTile(
                label: l10n.settingsLanguageEn,
                locale: const Locale('en'),
                currentLocale: currentLocale,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String label;
  final Locale locale;
  final Locale currentLocale;

  const _LanguageTile({
    required this.label,
    required this.locale,
    required this.currentLocale,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentLocale.languageCode == locale.languageCode;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppTheme.primaryLight : AppTheme.onBackground,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          fontSize: 15,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_rounded, color: AppTheme.primaryLight, size: 20)
          : null,
      onTap: () => TranszendentApp.localeNotifier.value = locale,
    );
  }
}
