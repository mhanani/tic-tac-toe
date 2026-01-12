import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tic_tac_toe/core/extensions/extensions.dart';
import 'package:tic_tac_toe/core/theme/app_theme.dart';
import 'package:tic_tac_toe/core/ui/widgets/custom_icon.dart';
import 'package:tic_tac_toe/features/settings/domain/entities/app_locale.dart';
import 'package:tic_tac_toe/features/settings/presentation/providers/settings_provider.dart';
import 'package:tic_tac_toe/features/settings/presentation/widgets/language_tile.dart';

/// Settings page with language selection
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        leading: CustomIcon.icon(Icons.arrow_back, onTap: () => context.pop()),
        title: Text(l10n.settings),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          children: [
            // Language section
            Text(l10n.language, style: AppTheme.headingSmall),
            const SizedBox(height: AppTheme.spacingMd),

            // Language options
            LanguageTile(
              locale: AppLocale.system,
              title: l10n.systemDefault,
              isSelected: currentLocale == AppLocale.system,
              onTap: () => _setLocale(ref, AppLocale.system),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            LanguageTile(
              locale: AppLocale.en,
              title: l10n.english,
              isSelected: currentLocale == AppLocale.en,
              onTap: () => _setLocale(ref, AppLocale.en),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            LanguageTile(
              locale: AppLocale.fr,
              title: l10n.french,
              isSelected: currentLocale == AppLocale.fr,
              onTap: () => _setLocale(ref, AppLocale.fr),
            ),
          ],
        ),
      ),
    );
  }

  void _setLocale(WidgetRef ref, AppLocale locale) {
    ref.read(localeProvider.notifier).setLocale(locale);
  }
}
