import 'package:tic_tac_toe/features/game/domain/entities/entities.dart';

/// Use case for playing a move on the board
class PlayMove {
  /// Executes a move at the given index for the current player
  /// Returns the updated game state with the move applied
  /// Throws [StateError] if the move is invalid
  Game call(Game game, int index) {
    if (game.status.isGameOver) {
      throw StateError('Cannot play move: game is already over');
    }

    if (!game.board.isCellEmpty(index)) {
      throw StateError('Cannot play move: cell is already occupied');
    }

    final newBoard = game.board.makeMove(index, game.currentPlayer);

    return game.copyWith(
      board: newBoard,
      currentPlayer: game.currentPlayer.opponent,
    );
  }
}
