import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/game/domain/entities/entities.dart';
import '../../features/game/presentation/pages/game_intro_page.dart';
import '../../features/game/presentation/pages/game_over_page.dart';
import '../../features/game/presentation/pages/game_page.dart';
import '../../features/game/presentation/providers/game_provider.dart';
import '../ui/widgets/widgets.dart';
import '../observer/app_navigator_observer.dart';

part 'app_router.g.dart';

/// Route paths
abstract class AppRoutes {
  static const home = '/';
  static const game = '/game';
  static const gameOver = '/game-over';
}

/// Provider for the GoRouter instance
@Riverpod(keepAlive: true)
GoRouter appRouter(AppRouterRef ref) {
  final routerNotifier = ref.watch(gameRouterNotifierProvider);

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
    ],
    errorBuilder: (context, state) => UnknownPage(
      path: state.uri.toString(),
    ),
  );
}
