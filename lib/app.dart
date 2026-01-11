import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tic_tac_toe/core/extensions/extensions.dart';
import 'package:tic_tac_toe/core/l10n/app_localizations.dart';
import 'package:tic_tac_toe/core/router/app_router.dart';
import 'package:tic_tac_toe/core/theme/app_theme.dart';
import 'package:tic_tac_toe/core/ui/widgets/widgets.dart';
import 'package:tic_tac_toe/features/game/presentation/providers/game_provider.dart';
import 'package:tic_tac_toe/features/settings/presentation/providers/settings_provider.dart';

/// Main app widget wrapped with ProviderScope
class TicTacToeApp extends ConsumerWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(appLocaleProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      theme: AppTheme.theme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

/// Loading widget while SharedPreferences initializes
class AppLoader extends ConsumerWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(sharedPreferencesProvider);

    return prefsAsync.when(
      data: (_) => const TicTacToeApp(),
      loading: () => MaterialApp(
        theme: AppTheme.theme,
        debugShowCheckedModeBanner: false,
        home: const Scaffold(body: AppLoading()),
      ),
      error: (error, stack) => MaterialApp(
        theme: AppTheme.theme,
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: Text('Error: $error'))),
      ),
    );
  }
}
