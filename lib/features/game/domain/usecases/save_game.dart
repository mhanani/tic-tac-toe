import 'package:dartz/dartz.dart';

import 'package:tic_tac_toe/core/error/failures.dart';
import 'package:tic_tac_toe/features/game/domain/entities/entities.dart';
import 'package:tic_tac_toe/features/game/domain/repositories/game_repository.dart';

/// Use case for saving the game state
class SaveGame {
  final GameRepository _repository;

  SaveGame(this._repository);

  Future<Either<Failure, Unit>> call(Game game) async {
    final gameResult = await _repository.saveGame(game);

    if (gameResult.isLeft()) {
      return gameResult;
    }

    // Save scores
    final scoresResult = await _repository.saveScores(
      xWins: game.xWins,
      oWins: game.oWins,
      draws: game.draws,
    );

    return scoresResult;
  }
}
