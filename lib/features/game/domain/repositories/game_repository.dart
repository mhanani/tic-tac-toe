import 'package:dartz/dartz.dart';
import 'package:tic_tac_toe/core/error/failures.dart';
import 'package:tic_tac_toe/features/game/domain/entities/entities.dart';

/// Abstract repository interface for game persistence
abstract class GameRepository {
  Future<Either<Failure, Unit>> saveGame(Game game);
  Future<Either<Failure, Game?>> loadGame();
  Future<Either<Failure, Unit>> clearGame();
  Future<Either<Failure, Unit>> saveScores({
    required int xWins,
    required int oWins,
    required int draws,
  });
  Future<Either<Failure, ({int xWins, int oWins, int draws})>> loadScores();
}
