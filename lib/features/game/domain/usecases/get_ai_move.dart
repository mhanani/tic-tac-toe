import 'dart:math';

import '../entities/entities.dart';

/// Use case for getting the AI's move
/// Uses a strategic approach:
/// 1. Win if possible
/// 2. Block opponent's win
/// 3. Take center
/// 4. Take corner
/// 5. Take any available cell
class GetAiMove {
  final Random _random = Random();

  /// Returns the index of the best move for the AI (Player O)
  /// Returns null if no move is available
  int? call(Game game) {
    final board = game.board;
    final emptyCells = board.emptyCells;

    if (emptyCells.isEmpty) return null;

    // AI is always Player O
    const aiPlayer = Player.o;
    const humanPlayer = Player.x;

    // 1. Check if AI can win
    final winningMove = _findWinningMove(board, aiPlayer);
    if (winningMove != null) return winningMove;

    // 2. Block opponent's winning move
    final blockingMove = _findWinningMove(board, humanPlayer);
    if (blockingMove != null) return blockingMove;

    // 3. Take center if available
    if (board.isCellEmpty(4)) return 4;

    // 4. Take a corner if available
    const corners = [0, 2, 6, 8];
    final availableCorners =
        corners.where((i) => board.isCellEmpty(i)).toList();
    if (availableCorners.isNotEmpty) {
      return availableCorners[_random.nextInt(availableCorners.length)];
    }

    // 5. Take any available edge
    const edges = [1, 3, 5, 7];
    final availableEdges = edges.where((i) => board.isCellEmpty(i)).toList();
    if (availableEdges.isNotEmpty) {
      return availableEdges[_random.nextInt(availableEdges.length)];
    }

    // Fallback: take any empty cell
    return emptyCells[_random.nextInt(emptyCells.length)];
  }

  /// Finds a winning move for the given player
  int? _findWinningMove(Board board, Player player) {
    for (final combo in Board.winningCombinations) {
      final cells = combo.map((i) => board.getCell(i)).toList();
      final playerCount = cells.where((c) => c == player).length;
      final emptyCount = cells.where((c) => c == Player.none).length;

      // If player has 2 in a row and one empty, that's a winning move
      if (playerCount == 2 && emptyCount == 1) {
        for (final i in combo) {
          if (board.isCellEmpty(i)) return i;
        }
      }
    }
    return null;
  }
}
