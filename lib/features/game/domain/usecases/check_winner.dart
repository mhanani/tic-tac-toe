import 'package:tic_tac_toe/features/game/domain/entities/entities.dart';

/// Use case for checking if there's a winner or draw
class CheckWinner {
  /// Checks the current game state and returns the updated game status
  Game call(Game game) {
    // Check for winner
    for (final combo in Board.winningCombinations) {
      final a = game.board.getCell(combo[0]);
      final b = game.board.getCell(combo[1]);
      final c = game.board.getCell(combo[2]);

      if (a != Player.none && a == b && b == c) {
        final newStatus = a == Player.x ? GameStatus.xWins : GameStatus.oWins;

        // Update scores
        final newXWins =
            newStatus == GameStatus.xWins ? game.xWins + 1 : game.xWins;
        final newOWins =
            newStatus == GameStatus.oWins ? game.oWins + 1 : game.oWins;

        return game.copyWith(
          status: newStatus,
          xWins: newXWins,
          oWins: newOWins,
        );
      }
    }

    // Check for draw
    if (game.board.isFull) {
      return game.copyWith(
        status: GameStatus.draw,
        draws: game.draws + 1,
      );
    }

    // Game continues
    return game.copyWith(status: GameStatus.inProgress);
  }
}
