import 'package:flutter_test/flutter_test.dart';

import 'package:tic_tac_toe/features/game/domain/entities/entities.dart';
import 'package:tic_tac_toe/features/game/domain/usecases/play_move.dart';

void main() {
  late PlayMove playMove;

  setUp(() {
    playMove = PlayMove();
  });

  group('PlayMove', () {
    group('valid moves', () {
      test('places move on empty cell', () {
        final game = Game.initial();

        final result = playMove(game, 0);

        expect(result.board.getCell(0), Player.x);
      });

      test('switches from X to O after X moves', () {
        final game = Game.initial();

        final result = playMove(game, 0);

        expect(result.currentPlayer, Player.o);
      });

      test('switches from O to X after O moves', () {
        final game = Game(
          board: Board.empty().makeMove(0, Player.x),
          currentPlayer: Player.o,
          status: GameStatus.inProgress,
          mode: GameMode.playerVsPlayer,
        );

        final result = playMove(game, 4);

        expect(result.board.getCell(4), Player.o);
        expect(result.currentPlayer, Player.x);
      });

      test('preserves existing moves on board', () {
        var game = Game.initial();
        game = playMove(game, 0);
        game = playMove(game, 4);

        final result = playMove(game, 8);

        expect(result.board.getCell(0), Player.x);
        expect(result.board.getCell(4), Player.o);
        expect(result.board.getCell(8), Player.x);
      });

      test('preserves game mode', () {
        final game = Game.initial(mode: GameMode.playerVsAi);

        final result = playMove(game, 0);

        expect(result.mode, GameMode.playerVsAi);
      });

      test('preserves scores', () {
        final game = Game(
          board: Board.empty(),
          currentPlayer: Player.x,
          status: GameStatus.inProgress,
          mode: GameMode.playerVsPlayer,
          xWins: 5,
          oWins: 3,
          draws: 2,
        );

        final result = playMove(game, 0);

        expect(result.xWins, 5);
        expect(result.oWins, 3);
        expect(result.draws, 2);
      });
    });

    group('invalid moves', () {
      test('throws StateError when game is over (xWins)', () {
        final game = Game(
          board: Board.empty(),
          currentPlayer: Player.x,
          status: GameStatus.xWins,
          mode: GameMode.playerVsPlayer,
        );

        expect(() => playMove(game, 0), throwsStateError);
      });

      test('throws StateError when game is over (oWins)', () {
        final game = Game(
          board: Board.empty(),
          currentPlayer: Player.x,
          status: GameStatus.oWins,
          mode: GameMode.playerVsPlayer,
        );

        expect(() => playMove(game, 0), throwsStateError);
      });

      test('throws StateError when game is over (draw)', () {
        final game = Game(
          board: Board.empty(),
          currentPlayer: Player.x,
          status: GameStatus.draw,
          mode: GameMode.playerVsPlayer,
        );

        expect(() => playMove(game, 0), throwsStateError);
      });

      test('throws StateError for occupied cell', () {
        final game = Game(
          board: Board.empty().makeMove(0, Player.x),
          currentPlayer: Player.o,
          status: GameStatus.inProgress,
          mode: GameMode.playerVsPlayer,
        );

        expect(() => playMove(game, 0), throwsStateError);
      });
    });

    group('does not change original game', () {
      test('original game board is unchanged after move', () {
        final game = Game.initial();
        playMove(game, 0);

        expect(game.board.getCell(0), Player.none);
        expect(game.currentPlayer, Player.x);
      });
    });
  });
}
