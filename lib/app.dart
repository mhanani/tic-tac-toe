import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/ui/widgets/widgets.dart';
import 'features/game/presentation/providers/game_provider.dart';

/// Main app widget wrapped with ProviderScope
class TicTacToeApp extends ConsumerWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Tic Tac Toe',
      theme: AppTheme.theme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
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
        home: const Scaffold(
          body: AppLoading(),
        ),
      ),
      error: (error, stack) => MaterialApp(
        theme: AppTheme.theme,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Text('Error: $error'),
          ),
        ),
      ),
    );
  }
}
