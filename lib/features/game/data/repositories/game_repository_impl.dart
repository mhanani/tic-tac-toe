import 'package:tic_tac_toe/features/game/data/datasources/game_local_datasource.dart';
import 'package:tic_tac_toe/features/game/data/models/game_model.dart';
import 'package:tic_tac_toe/features/game/domain/entities/entities.dart';
import 'package:tic_tac_toe/features/game/domain/repositories/game_repository.dart';

/// Implementation of GameRepository using local data source
class GameRepositoryImpl implements GameRepository {
  final GameLocalDataSource _localDataSource;

  GameRepositoryImpl(this._localDataSource);

  @override
  Future<void> saveGame(Game game) async {
    await _localDataSource.saveGame(game.toModel());
  }

  @override
  Future<Game?> loadGame() async {
    final model = await _localDataSource.loadGame();
    return model?.toEntity();
  }

  @override
  Future<void> clearGame() async {
    await _localDataSource.clearGame();
  }

  @override
  Future<void> saveScores({
    required int xWins,
    required int oWins,
    required int draws,
  }) async {
    await _localDataSource.saveScores(xWins, oWins, draws);
  }

  @override
  Future<({int xWins, int oWins, int draws})> loadScores() async {
    return _localDataSource.loadScores();
  }
}
