import 'package:tic_tac_toe/features/game/domain/entities/entities.dart';
import 'package:tic_tac_toe/features/game/domain/repositories/game_repository.dart';

/// Use case for loading a saved game
class LoadGame {
  final GameRepository _repository;

  LoadGame(this._repository);

  Future<Game?> call() async {
    final game = await _repository.loadGame();
    if (game == null) return null;

    // Load scores and merge them
    final scores = await _repository.loadScores();
    return game.copyWith(
      xWins: scores.xWins,
      oWins: scores.oWins,
      draws: scores.draws,
    );
  }
}
