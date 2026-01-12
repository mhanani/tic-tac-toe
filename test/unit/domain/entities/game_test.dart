import 'package:flutter_test/flutter_test.dart';

import 'package:tic_tac_toe/features/game/domain/entities/entities.dart';

void main() {
  group('Game', () {
    group('Game.initial', () {
      test('creates a game with default values', () {
        final game = Game.initial();

        expect(game.board.cells.every((c) => c == Player.none), true);
        expect(game.currentPlayer, Player.x);
        expect(game.status, GameStatus.inProgress);
        expect(game.mode, GameMode.playerVsPlayer);
        expect(game.difficulty, isNull);
        expect(game.xWins, 0);
        expect(game.oWins, 0);
        expect(game.draws, 0);
      });

      test('creates a game with specified mode', () {
        final game = Game.initial(mode: GameMode.playerVsAi);

        expect(game.mode, GameMode.playerVsAi);
      });

      test('creates a game with specified difficulty', () {
        final game = Game.initial(
          mode: GameMode.playerVsAi,
          difficulty: AiDifficulty.expert,
        );

        expect(game.difficulty, AiDifficulty.expert);
      });
    });

    group('newRound', () {
      test('preserves scores when starting new round', () {
        final game = Game(
          board: Board.empty(),
          currentPlayer: Player.o,
          status: GameStatus.xWins,
          mode: GameMode.playerVsPlayer,
          xWins: 3,
          oWins: 2,
          draws: 1,
        );

        final newRound = game.newRound();

        expect(newRound.board.cells.every((c) => c == Player.none), true);
        expect(newRound.currentPlayer, Player.x);
        expect(newRound.status, GameStatus.inProgress);
        expect(newRound.mode, GameMode.playerVsPlayer);
        expect(newRound.xWins, 3);
        expect(newRound.oWins, 2);
        expect(newRound.draws, 1);
      });

      test('preserves mode and difficulty when starting new round', () {
        final game = Game(
          board: Board.empty(),
          currentPlayer: Player.o,
          status: GameStatus.oWins,
          mode: GameMode.playerVsAi,
          difficulty: AiDifficulty.expert,
          xWins: 1,
          oWins: 2,
          draws: 0,
        );

        final newRound = game.newRound();

        expect(newRound.mode, GameMode.playerVsAi);
        expect(newRound.difficulty, AiDifficulty.expert);
      });
    });

    group('copyWith', () {
      test('updates board field', () {
        final game = Game.initial();
        final newBoard = Board.empty().makeMove(0, Player.x);
        final updatedGame = game.copyWith(board: newBoard);

        expect(updatedGame.board.getCell(0), Player.x);
        expect(game.board.getCell(0), Player.none); // Original unchanged
      });

      test('updates currentPlayer field', () {
        final game = Game.initial();
        final updatedGame = game.copyWith(currentPlayer: Player.o);

        expect(updatedGame.currentPlayer, Player.o);
        expect(game.currentPlayer, Player.x); // Original unchanged
      });

      test('updates status field', () {
        final game = Game.initial();
        final updatedGame = game.copyWith(status: GameStatus.xWins);

        expect(updatedGame.status, GameStatus.xWins);
        expect(game.status, GameStatus.inProgress); // Original unchanged
      });

      test('updates mode field', () {
        final game = Game.initial();
        final updatedGame = game.copyWith(mode: GameMode.playerVsAi);

        expect(updatedGame.mode, GameMode.playerVsAi);
        expect(game.mode, GameMode.playerVsPlayer); // Original unchanged
      });

      test('updates score fields', () {
        final game = Game.initial();
        final updatedGame = game.copyWith(xWins: 5, oWins: 3, draws: 2);

        expect(updatedGame.xWins, 5);
        expect(updatedGame.oWins, 3);
        expect(updatedGame.draws, 2);
        expect(game.xWins, 0); // Original unchanged
      });

      test('preserves unchanged fields', () {
        final game = Game(
          board: Board.empty().makeMove(4, Player.x),
          currentPlayer: Player.o,
          status: GameStatus.inProgress,
          mode: GameMode.playerVsAi,
          difficulty: AiDifficulty.chill,
          xWins: 1,
          oWins: 2,
          draws: 3,
        );

        final updatedGame = game.copyWith(xWins: 10);

        expect(updatedGame.board.getCell(4), Player.x);
        expect(updatedGame.currentPlayer, Player.o);
        expect(updatedGame.status, GameStatus.inProgress);
        expect(updatedGame.mode, GameMode.playerVsAi);
        expect(updatedGame.difficulty, AiDifficulty.chill);
        expect(updatedGame.xWins, 10);
        expect(updatedGame.oWins, 2);
        expect(updatedGame.draws, 3);
      });
    });

    group('equality', () {
      test('two games with same values are equal', () {
        final game1 = Game.initial();
        final game2 = Game.initial();

        expect(game1, game2);
      });

      test('games with different boards are not equal', () {
        final game1 = Game.initial();
        final game2 = game1.copyWith(
          board: Board.empty().makeMove(0, Player.x),
        );

        expect(game1, isNot(game2));
      });

      test('games with different currentPlayer are not equal', () {
        final game1 = Game.initial();
        final game2 = game1.copyWith(currentPlayer: Player.o);

        expect(game1, isNot(game2));
      });

      test('games with different status are not equal', () {
        final game1 = Game.initial();
        final game2 = game1.copyWith(status: GameStatus.xWins);

        expect(game1, isNot(game2));
      });

      test('games with different scores are not equal', () {
        final game1 = Game.initial();
        final game2 = game1.copyWith(xWins: 1);

        expect(game1, isNot(game2));
      });

      test('hashCodes are equal for equal games', () {
        final game1 = Game.initial();
        final game2 = Game.initial();

        expect(game1.hashCode, game2.hashCode);
      });
    });
  });
}
