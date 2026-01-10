import '../entities/entities.dart';
import '../repositories/game_repository.dart';

/// Use case for saving the game state
class SaveGame {
  final GameRepository _repository;

  SaveGame(this._repository);

  Future<void> call(Game game) async {
    await _repository.saveGame(game);
    await _repository.saveScores(
      xWins: game.xWins,
      oWins: game.oWins,
      draws: game.draws,
    );
  }
}
