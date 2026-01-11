import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tic_tac_toe/core/observer/app_navigator_observer.dart';
import 'package:tic_tac_toe/core/ui/widgets/widgets.dart';
import 'package:tic_tac_toe/features/game/domain/entities/entities.dart';
import 'package:tic_tac_toe/features/game/presentation/pages/game_intro_page.dart';
import 'package:tic_tac_toe/features/game/presentation/pages/game_over_page.dart';
import 'package:tic_tac_toe/features/game/presentation/pages/game_page.dart';
import 'package:tic_tac_toe/features/game/presentation/providers/game_provider.dart';
import 'package:tic_tac_toe/features/settings/presentation/pages/settings_page.dart';

part 'app_router.g.dart';

/// Route paths
abstract class AppRoutes {
  static const home = '/';
  static const game = '/game';
  static const gameOver = '/game-over';
  static const settings = '/settings';
}

/// Provider for the GoRouter instance
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final routerNotifier = ref.watch(gameRouterProvider);

  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    observers: [AppNavigatorObserver()],
    refreshListenable: routerNotifier,
    redirect: (context, state) {
      final gameStatus = routerNotifier.value;
      final currentPath = state.matchedLocation;

      // If game is over and we're on the game page, go to game over
      if (gameStatus.isGameOver && currentPath == AppRoutes.game) {
        return AppRoutes.gameOver;
      }

      // If game is in progress and we're on game over, go back to game
      if (gameStatus == GameStatus.inProgress &&
          currentPath == AppRoutes.gameOver) {
        return AppRoutes.game;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const GameIntroPage(),
      ),
      GoRoute(
        path: AppRoutes.game,
        name: 'game',
        builder: (context, state) => const GamePage(),
      ),
      GoRoute(
        path: AppRoutes.gameOver,
        name: 'gameOver',
        builder: (context, state) => const GameOverPage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
    errorBuilder: (context, state) => UnknownPage(path: state.uri.toString()),
  );
}
