import 'package:flutter_test/flutter_test.dart';

import 'package:tic_tac_toe/features/game/domain/entities/entities.dart';
import 'package:tic_tac_toe/features/game/domain/usecases/check_winner.dart';

void main() {
  late CheckWinner checkWinner;

  setUp(() {
    checkWinner = CheckWinner();
  });

  group('CheckWinner', () {
    group('horizontal wins', () {
      test('returns xWins for X winning top row', () {
        // X X X
        // O O .
        // . . .
        final board = Board.fromCells([
          Player.x,
          Player.x,
          Player.x,
          Player.o,
          Player.o,
          Player.none,
          Player.none,
          Player.none,
          Player.none,
        ]);
        final game = Game(
          board: board,
          currentPlayer: Player.o,
          status: GameStatus.inProgress,
          mode: GameMode.playerVsPlayer,
        );

        final result = checkWinner(game);

        expect(result.status, GameStatus.xWins);
      });

      test('returns oWins for O winning middle row', () {
        // X X .
        // O O O
        // X . .
        final board = Board.fromCells([
          Player.x,
          Player.x,
          Player.none,
          Player.o,
          Player.o,
          Player.o,
          Player.x,
          Player.none,
          Player.none,
        ]);
        final game = Game(
          board: board,
          currentPlayer: Player.x,
          status: GameStatus.inProgress,
          mode: GameMode.playerVsPlayer,
        );

        final result = checkWinner(game);

        expect(result.status, GameStatus.oWins);
      });

      test('returns xWins for X winning bottom row', () {
        // O O .
        // O . .
        // X X X
        final board = Board.fromCells([
          Player.o,
          Player.o,
          Player.none,
          Player.o,
          Player.none,
          Player.none,
          Player.x,
          Player.x,
          Player.x,
        ]);
        final game = Game(
          board: board,
          currentPlayer: Player.o,
          status: GameStatus.inProgress,
          mode: GameMode.playerVsPlayer,
        );

        final result = checkWinner(game);

        expect(result.status, GameStatus.xWins);
      });
    });

    group('vertical wins', () {
      test('returns xWins for X winning left column', () {
        // X O .
        // X O .
        // X . .
        final board = Board.fromCells([
          Player.x,
          Player.o,
          Player.none,
          Player.x,
          Player.o,
          Player.none,
          Player.x,
          Player.none,
          Player.none,
        ]);
        final game = Game(
          board: board,
          currentPlayer: Player.o,
          status: GameStatus.inProgress,
          mode: GameMode.playerVsPlayer,
        );

        final result = checkWinner(game);

        expect(result.status, GameStatus.xWins);
      });

      test('returns oWins for O winning middle column', () {
        // X O X
        // . O .
        // X O .
        final board = Board.fromCells([
          Player.x,
          Player.o,
          Player.x,
          Player.none,
          Player.o,
          Player.none,
          Player.x,
          Player.o,
          Player.none,
        ]);
        final game = Game(
          board: board,
          currentPlayer: Player.x,
          status: GameStatus.inProgress,
          mode: GameMode.playerVsPlayer,
        );

        final result = checkWinner(game);

        expect(result.status, GameStatus.oWins);
      });

      test('returns xWins for X winning right column', () {
        // O O X
        // . . X
        // O . X
        final board = Board.fromCells([
          Player.o,
          Player.o,
          Player.x,
          Player.none,
          Player.none,
          Player.x,
          Player.o,
          Player.none,
          Player.x,
        ]);
        final game = Game(
          board: board,
          currentPlayer: Player.o,
          status: GameStatus.inProgress,
          mode: GameMode.playerVsPlayer,
        );

        final result = checkWinner(game);

        expect(result.status, GameStatus.xWins);
      });
    });

    group('diagonal wins', () {
      test('returns xWins for X winning main diagonal', () {
        // X O .
        // O X .
        // . . X
        final board = Board.fromCells([
          Player.x,
          Player.o,
          Player.none,
          Player.o,
          Player.x,
          Player.none,
          Player.none,
          Player.none,
          Player.x,
        ]);
        final game = Game(
          board: board,
          currentPlayer: Player.o,
          status: GameStatus.inProgress,
          mode: GameMode.playerVsPlayer,
        );

        final result = checkWinner(game);

        expect(result.status, GameStatus.xWins);
      });

      test('returns oWins for O winning anti-diagonal', () {
        // X X O
        // X O .
        // O . .
        final board = Board.fromCells([
          Player.x,
          Player.x,
          Player.o,
          Player.x,
          Player.o,
          Player.none,
          Player.o,
          Player.none,
          Player.none,
        ]);
        final game = Game(
          board: board,
          currentPlayer: Player.x,
          status: GameStatus.inProgress,
          mode: GameMode.playerVsPlayer,
        );

        final result = checkWinner(game);

        expect(result.status, GameStatus.oWins);
      });
    });

    group('draw', () {
      test('returns draw when board is full with no winner', () {
        // X O X
        // X O O
        // O X X
        final board = Board.fromCells([
          Player.x,
          Player.o,
          Player.x,
          Player.x,
          Player.o,
          Player.o,
          Player.o,
          Player.x,
          Player.x,
        ]);
        final game = Game(
          board: board,
          currentPlayer: Player.x,
          status: GameStatus.inProgress,
          mode: GameMode.playerVsPlayer,
        );

        final result = checkWinner(game);

        expect(result.status, GameStatus.draw);
      });
    });

    group('in progress', () {
      test('returns inProgress when game continues', () {
        // X O .
        // . X .
        // . . .
        final board = Board.fromCells([
          Player.x,
          Player.o,
          Player.none,
          Player.none,
          Player.x,
          Player.none,
          Player.none,
          Player.none,
          Player.none,
        ]);
        final game = Game(
          board: board,
          currentPlayer: Player.o,
          status: GameStatus.inProgress,
          mode: GameMode.playerVsPlayer,
        );

        final result = checkWinner(game);

        expect(result.status, GameStatus.inProgress);
      });

      test('returns inProgress for empty board', () {
        final game = Game.initial();

        final result = checkWinner(game);

        expect(result.status, GameStatus.inProgress);
      });
    });

    group('score updates', () {
      test('increments xWins counter on X win', () {
        // X X X
        // O O .
        // . . .
        final board = Board.fromCells([
          Player.x,
          Player.x,
          Player.x,
          Player.o,
          Player.o,
          Player.none,
          Player.none,
          Player.none,
          Player.none,
        ]);
        final game = Game(
          board: board,
          currentPlayer: Player.o,
          status: GameStatus.inProgress,
          mode: GameMode.playerVsPlayer,
          xWins: 2,
          oWins: 1,
          draws: 0,
        );

        final result = checkWinner(game);

        expect(result.xWins, 3);
        expect(result.oWins, 1);
        expect(result.draws, 0);
      });

      test('increments oWins counter on O win', () {
        // X X .
        // O O O
        // X . .
        final board = Board.fromCells([
          Player.x,
          Player.x,
          Player.none,
          Player.o,
          Player.o,
          Player.o,
          Player.x,
          Player.none,
          Player.none,
        ]);
        final game = Game(
          board: board,
          currentPlayer: Player.x,
          status: GameStatus.inProgress,
          mode: GameMode.playerVsPlayer,
          xWins: 1,
          oWins: 2,
          draws: 1,
        );

        final result = checkWinner(game);

        expect(result.xWins, 1);
        expect(result.oWins, 3);
        expect(result.draws, 1);
      });

      test('increments draws counter on draw', () {
        // X O X
        // X O O
        // O X X
        final board = Board.fromCells([
          Player.x,
          Player.o,
          Player.x,
          Player.x,
          Player.o,
          Player.o,
          Player.o,
          Player.x,
          Player.x,
        ]);
        final game = Game(
          board: board,
          currentPlayer: Player.x,
          status: GameStatus.inProgress,
          mode: GameMode.playerVsPlayer,
          xWins: 3,
          oWins: 3,
          draws: 2,
        );

        final result = checkWinner(game);

        expect(result.xWins, 3);
        expect(result.oWins, 3);
        expect(result.draws, 3);
      });

      test('does not change scores when game continues', () {
        final game = Game(
          board: Board.empty().makeMove(0, Player.x),
          currentPlayer: Player.o,
          status: GameStatus.inProgress,
          mode: GameMode.playerVsPlayer,
          xWins: 5,
          oWins: 3,
          draws: 2,
        );

        final result = checkWinner(game);

        expect(result.xWins, 5);
        expect(result.oWins, 3);
        expect(result.draws, 2);
      });
    });
  });
}
