import 'package:flutter_test/flutter_test.dart';

import 'package:tic_tac_toe/features/game/domain/entities/board.dart';
import 'package:tic_tac_toe/features/game/domain/entities/player.dart';

void main() {
  group('Board', () {
    group('Board.empty', () {
      test('creates a board with 9 empty cells', () {
        final board = Board.empty();

        expect(board.cells.length, 9);
        expect(board.cells.every((cell) => cell == Player.none), true);
      });
    });

    group('Board.fromCells', () {
      test('creates a board with given cells', () {
        final cells = [
          Player.x,
          Player.o,
          Player.none,
          Player.none,
          Player.x,
          Player.none,
          Player.none,
          Player.none,
          Player.o,
        ];

        final board = Board.fromCells(cells);

        expect(board.cells.length, 9);
        expect(board.getCell(0), Player.x);
        expect(board.getCell(1), Player.o);
        expect(board.getCell(4), Player.x);
        expect(board.getCell(8), Player.o);
      });

      test('throws assertion error for wrong number of cells', () {
        expect(
          () => Board.fromCells([Player.x, Player.o]),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('makeMove', () {
      test('places player at correct index', () {
        final board = Board.empty();
        final newBoard = board.makeMove(0, Player.x);

        expect(newBoard.getCell(0), Player.x);
        expect(board.getCell(0), Player.none); // Original unchanged
      });

      test('throws StateError on occupied cell', () {
        final board = Board.empty().makeMove(0, Player.x);

        expect(() => board.makeMove(0, Player.o), throwsStateError);
      });

      test('throws ArgumentError for negative index', () {
        final board = Board.empty();

        expect(() => board.makeMove(-1, Player.x), throwsArgumentError);
      });

      test('throws ArgumentError for index greater than 8', () {
        final board = Board.empty();

        expect(() => board.makeMove(9, Player.x), throwsArgumentError);
      });
    });

    group('isCellEmpty', () {
      test('returns true for empty cell', () {
        final board = Board.empty();

        expect(board.isCellEmpty(0), true);
      });

      test('returns false for occupied cell', () {
        final board = Board.empty().makeMove(0, Player.x);

        expect(board.isCellEmpty(0), false);
      });
    });

    group('emptyCells', () {
      test('returns all indices for empty board', () {
        final board = Board.empty();

        expect(board.emptyCells, [0, 1, 2, 3, 4, 5, 6, 7, 8]);
      });

      test('returns only empty indices for partially filled board', () {
        var board = Board.empty();
        board = board.makeMove(0, Player.x);
        board = board.makeMove(4, Player.o);
        board = board.makeMove(8, Player.x);

        expect(board.emptyCells, [1, 2, 3, 5, 6, 7]);
      });

      test('returns empty list for full board', () {
        var board = Board.empty();
        for (var i = 0; i < 9; i++) {
          board = board.makeMove(i, i.isEven ? Player.x : Player.o);
        }

        expect(board.emptyCells, isEmpty);
      });
    });

    group('isFull', () {
      test('returns false for empty board', () {
        final board = Board.empty();

        expect(board.isFull, false);
      });

      test('returns false for partially filled board', () {
        final board = Board.empty().makeMove(0, Player.x);

        expect(board.isFull, false);
      });

      test('returns true for full board', () {
        var board = Board.empty();
        for (var i = 0; i < 9; i++) {
          board = board.makeMove(i, i.isEven ? Player.x : Player.o);
        }

        expect(board.isFull, true);
      });
    });

    group('getCell', () {
      test('returns correct player at index', () {
        var board = Board.empty();
        board = board.makeMove(0, Player.x);
        board = board.makeMove(4, Player.o);

        expect(board.getCell(0), Player.x);
        expect(board.getCell(4), Player.o);
        expect(board.getCell(8), Player.none);
      });
    });

    group('equality', () {
      test('two empty boards are equal', () {
        final board1 = Board.empty();
        final board2 = Board.empty();

        expect(board1, board2);
      });

      test('boards with same cells are equal', () {
        final board1 = Board.empty().makeMove(0, Player.x);
        final board2 = Board.empty().makeMove(0, Player.x);

        expect(board1, board2);
      });

      test('boards with different cells are not equal', () {
        final board1 = Board.empty().makeMove(0, Player.x);
        final board2 = Board.empty().makeMove(0, Player.o);

        expect(board1, isNot(board2));
      });

      test('hashCodes are equal for equal boards', () {
        final board1 = Board.empty().makeMove(0, Player.x);
        final board2 = Board.empty().makeMove(0, Player.x);

        expect(board1.hashCode, board2.hashCode);
      });
    });

    group('winningCombinations', () {
      test('contains all 8 winning combinations', () {
        expect(Board.winningCombinations.length, 8);
      });

      test('contains horizontal rows', () {
        // Top row
        expect(Board.winningCombinations[0], [0, 1, 2]);
        // Middle row
        expect(Board.winningCombinations[1], [3, 4, 5]);
        // Bottom row
        expect(Board.winningCombinations[2], [6, 7, 8]);
      });

      test('contains vertical columns', () {
        // Left column
        expect(Board.winningCombinations[3], [0, 3, 6]);
        // Middle column
        expect(Board.winningCombinations[4], [1, 4, 7]);
        // Right column
        expect(Board.winningCombinations[5], [2, 5, 8]);
      });

      test('contains diagonals', () {
        // Main diagonal
        expect(Board.winningCombinations[6], [0, 4, 8]);
        // Anti-diagonal
        expect(Board.winningCombinations[7], [2, 4, 6]);
      });
    });
  });
}
