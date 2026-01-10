import '../entities/entities.dart';

/// Abstract repository interface for game persistence
abstract class GameRepository {
  /// Saves the current game state
  Future<void> saveGame(Game game);

  /// Loads the saved game state
  Future<Game?> loadGame();

  /// Clears the saved game state
  Future<void> clearGame();

  /// Saves the score statistics
  Future<void> saveScores({
    required int xWins,
    required int oWins,
    required int draws,
  });

  /// Loads the score statistics
  Future<({int xWins, int oWins, int draws})> loadScores();
}
