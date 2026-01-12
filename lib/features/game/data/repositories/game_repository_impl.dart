import 'package:dartz/dartz.dart';

import 'package:tic_tac_toe/core/error/failures.dart';
import 'package:tic_tac_toe/core/utils/logger.dart';
import 'package:tic_tac_toe/features/game/data/datasources/game_local_datasource.dart';
import 'package:tic_tac_toe/features/game/data/models/game_model.dart';
import 'package:tic_tac_toe/features/game/domain/entities/entities.dart';
import 'package:tic_tac_toe/features/game/domain/repositories/game_repository.dart';

/// Implementation of GameRepository using local data source
class GameRepositoryImpl implements GameRepository {
  final GameLocalDataSource _localDataSource;

  GameRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, Unit>> saveGame(Game game) async {
    try {
      await _localDataSource.saveGame(game.toModel());
      return const Right(unit);
    } catch (e, stackTrace) {
      logger.e(
        'Failed to save game',
        tag: 'GameRepository',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        CacheFailure(
          message: 'Failed to save game: ${e.toString()}',
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Game?>> loadGame() async {
    try {
      final model = await _localDataSource.loadGame();
      return Right(model?.toEntity());
    } catch (e, stackTrace) {
      logger.e(
        'Failed to load game',
        tag: 'GameRepository',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        CacheFailure(
          message: 'Failed to load game: ${e.toString()}',
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> clearGame() async {
    try {
      await _localDataSource.clearGame();
      return const Right(unit);
    } catch (e, stackTrace) {
      logger.e(
        'Failed to clear game',
        tag: 'GameRepository',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        CacheFailure(
          message: 'Failed to clear game: ${e.toString()}',
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> saveScores({
    required int xWins,
    required int oWins,
    required int draws,
  }) async {
    try {
      await _localDataSource.saveScores(xWins, oWins, draws);
      return const Right(unit);
    } catch (e, stackTrace) {
      logger.e(
        'Failed to save scores',
        tag: 'GameRepository',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        CacheFailure(
          message: 'Failed to save scores: ${e.toString()}',
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ({int xWins, int oWins, int draws})>>
  loadScores() async {
    try {
      final scores = await _localDataSource.loadScores();
      return Right(scores);
    } catch (e, stackTrace) {
      logger.e(
        'Failed to load scores',
        tag: 'GameRepository',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        CacheFailure(
          message: 'Failed to load scores: ${e.toString()}',
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
