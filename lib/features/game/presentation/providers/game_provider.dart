import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tic_tac_toe/core/providers/shared_prefs_provider.dart';
import 'package:tic_tac_toe/features/game/data/datasources/game_local_datasource.dart';
import 'package:tic_tac_toe/features/game/data/repositories/game_repository_impl.dart';
import 'package:tic_tac_toe/features/game/domain/entities/entities.dart';
import 'package:tic_tac_toe/features/game/domain/repositories/game_repository.dart';
import 'package:tic_tac_toe/features/game/domain/usecases/usecases.dart';

part 'game_provider.g.dart';

/// Provider for the game local data source
@Riverpod(keepAlive: true)
GameLocalDataSource gameLocalDataSource(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return GameLocalDataSourceImpl(prefs);
}

/// Provider for the game repository
@Riverpod(keepAlive: true)
GameRepository gameRepository(Ref ref) {
  final dataSource = ref.watch(gameLocalDataSourceProvider);
  return GameRepositoryImpl(dataSource);
}

/// Provider for use cases
@riverpod
PlayMove playMoveUseCase(Ref ref) => PlayMove();

@riverpod
CheckWinner checkWinnerUseCase(Ref ref) => CheckWinner();

@riverpod
GetAiMove getAiMoveUseCase(Ref ref) => GetAiMove();

@riverpod
SaveGame saveGameUseCase(Ref ref) {
  final repository = ref.watch(gameRepositoryProvider);
  return SaveGame(repository);
}

@riverpod
LoadGame loadGameUseCase(Ref ref) {
  final repository = ref.watch(gameRepositoryProvider);
  return LoadGame(repository);
}

/// ValueNotifier for GoRouter refresh
class GameRouterNotifier extends ValueNotifier<GameStatus> {
  GameRouterNotifier() : super(GameStatus.notStarted);

  void update(GameStatus status) {
    if (value != status) {
      value = status;
    }
  }
}

/// Provider for the router notifier
@Riverpod(keepAlive: true)
GameRouterNotifier gameRouter(Ref ref) {
  return GameRouterNotifier();
}

/// Main game state notifier
@Riverpod(keepAlive: true)
class GameNotifier extends _$GameNotifier {
  @override
  Game build() {
    return Game.initial();
  }

  PlayMove get _playMove => ref.read(playMoveUseCaseProvider);
  CheckWinner get _checkWinner => ref.read(checkWinnerUseCaseProvider);
  GetAiMove get _getAiMove => ref.read(getAiMoveUseCaseProvider);

  void _updateRouterNotifier() {
    ref.read(gameRouterProvider).update(state.status);
  }

  /// Starts a new game with the given mode and optional difficulty (for AI mode)
  void startGame(GameMode mode, {AiDifficulty? difficulty}) {
    state = Game.initial(
      mode: mode,
      difficulty: difficulty,
    ).copyWith(xWins: state.xWins, oWins: state.oWins, draws: state.draws);
    _updateRouterNotifier();
  }

  /// Plays a move at the given index
  void playMove(int index) {
    if (state.status.isGameOver) return;
    if (!state.board.isCellEmpty(index)) return;

    try {
      // Play the move
      var newState = _playMove(state, index);
      // Check for winner
      newState = _checkWinner(newState);
      state = newState;
      _updateRouterNotifier();

      // Save game state
      _saveGame();

      // If it's AI's turn and game is not over, play AI move
      if (!state.status.isGameOver &&
          state.mode == GameMode.playerVsAi &&
          state.currentPlayer == Player.o) {
        _playAiMove();
      }
    } catch (_) {
      // Invalid move, ignore
    }
  }

  /// Plays the AI move
  void _playAiMove() {
    final aiMoveIndex = _getAiMove(state);
    if (aiMoveIndex == null) return;

    // Add a small delay for better UX
    Future.delayed(const Duration(milliseconds: 300), () {
      if (state.status.isGameOver) return;

      try {
        var newState = _playMove(state, aiMoveIndex);
        newState = _checkWinner(newState);
        state = newState;
        _updateRouterNotifier();
        _saveGame();
      } catch (_) {
        // Invalid move, ignore
      }
    });
  }

  /// Resets the current game (new round with same scores)
  void resetGame() {
    state = state.newRound();
    _updateRouterNotifier();
    _saveGame();
  }

  /// Resets everything including scores
  void resetAll() {
    state = Game.initial(mode: state.mode);
    _updateRouterNotifier();
    clearSavedGame();
  }

  /// Loads a saved game
  Future<void> loadSavedGame() async {
    final loadGame = ref.read(loadGameUseCaseProvider);
    final savedGame = await loadGame();
    if (savedGame != null) {
      state = savedGame;
      _updateRouterNotifier();
    }
  }

  /// Loads just the scores (for home screen)
  Future<void> loadScores() async {
    final repository = ref.read(gameRepositoryProvider);
    final scores = await repository.loadScores();
    state = state.copyWith(
      xWins: scores.xWins,
      oWins: scores.oWins,
      draws: scores.draws,
    );
  }

  /// Checks if there's a saved game in progress
  /// Returns the saved game if it exists and is in progress, null otherwise
  Future<Game?> checkForSavedGameInProgress() async {
    final loadGame = ref.read(loadGameUseCaseProvider);
    final savedGame = await loadGame();
    if (savedGame != null && savedGame.status == GameStatus.inProgress) {
      return savedGame;
    }
    return null;
  }

  void _saveGame() {
    final saveGame = ref.read(saveGameUseCaseProvider);
    saveGame(state);
  }

  /// Clears the saved game from storage (does not reset state)
  void clearSavedGame() {
    final repository = ref.read(gameRepositoryProvider);
    repository.clearGame();
  }
}
