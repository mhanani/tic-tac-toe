import 'package:dartz/dartz.dart';

import 'package:tic_tac_toe/core/error/failures.dart';
import 'package:tic_tac_toe/features/game/domain/entities/entities.dart';
import 'package:tic_tac_toe/features/game/domain/repositories/game_repository.dart';

/// Use case for loading a saved game
class LoadGame {
  final GameRepository _repository;

  LoadGame(this._repository);

  Future<Either<Failure, Game?>> call() async {
    final gameResult = await _repository.loadGame();

    return gameResult.fold((failure) => Left(failure), (game) async {
      if (game == null) {
        return const Right(null);
      }

      final scoresResult = await _repository.loadScores();

      return scoresResult.fold(
        (failure) => Left(failure),
        (scores) => Right(
          game.copyWith(
            xWins: scores.xWins,
            oWins: scores.oWins,
            draws: scores.draws,
          ),
        ),
      );
    });
  }
}
