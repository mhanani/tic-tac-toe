import 'package:flutter_test/flutter_test.dart';

import 'package:tic_tac_toe/features/game/domain/entities/entities.dart';
import 'package:tic_tac_toe/features/game/domain/usecases/get_ai_move.dart';

void main() {
  late GetAiMove getAiMove;

  setUp(() {
    getAiMove = GetAiMove();
  });

  group('GetAiMove', () {
    group('returns null', () {
      test('returns null when no moves available', () {
        // Full board
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
          currentPlayer: Player.o,
          status: GameStatus.inProgress,
          mode: GameMode.playerVsAi,
          difficulty: AiDifficulty.expert,
        );

        final result = getAiMove(game);

        expect(result, isNull);
      });
    });

    group('chill mode', () {
      test('returns a valid empty cell index', () {
        final game = Game.initial(
          mode: GameMode.playerVsAi,
          difficulty: AiDifficulty.chill,
        );

        final result = getAiMove(game);

        expect(result, isNotNull);
        expect(result, inInclusiveRange(0, 8));
        expect(game.board.isCellEmpty(result!), true);
      });

      test('returns the only empty cell when one remains', () {
        // Only cell 4 is empty
        final board = Board.fromCells([
          Player.x,
          Player.o,
          Player.x,
          Player.x,
          Player.none,
          Player.o,
          Player.o,
          Player.x,
          Player.o,
        ]);
        final game = Game(
          board: board,
          currentPlayer: Player.o,
          status: GameStatus.inProgress,
          mode: GameMode.playerVsAi,
          difficulty: AiDifficulty.chill,
        );

        final result = getAiMove(game);

        expect(result, 4);
      });

      test('multiple calls may return different cells (random)', () {
        final game = Game.initial(
          mode: GameMode.playerVsAi,
          difficulty: AiDifficulty.chill,
        );

        // Run multiple times to check randomness
        final results = <int>{};
        for (var i = 0; i < 100; i++) {
          final result = getAiMove(game);
          if (result != null) {
            results.add(result);
          }
        }

        // Should have at least 2 different results if random
        // (statistically very likely with 9 options and 100 tries)
        expect(results.length, greaterThan(1));
      });
    });

    group('expert mode', () {
      group('takes winning move', () {
        test('completes horizontal winning line', () {
          // O O .   -> AI should take index 2 to win
          // X X .
          // . . .
          final board = Board.fromCells([
            Player.o,
            Player.o,
            Player.none,
            Player.x,
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
            mode: GameMode.playerVsAi,
            difficulty: AiDifficulty.expert,
          );

          final result = getAiMove(game);

          expect(result, 2);
        });

        test('completes vertical winning line', () {
          // O X .
          // O X .
          // . . .   -> AI should take index 6 to win
          final board = Board.fromCells([
            Player.o,
            Player.x,
            Player.none,
            Player.o,
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
            mode: GameMode.playerVsAi,
            difficulty: AiDifficulty.expert,
          );

          final result = getAiMove(game);

          expect(result, 6);
        });

        test('completes diagonal winning line', () {
          // O X X
          // X O .
          // . . .   -> AI should take index 8 to win
          final board = Board.fromCells([
            Player.o,
            Player.x,
            Player.x,
            Player.x,
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
            mode: GameMode.playerVsAi,
            difficulty: AiDifficulty.expert,
          );

          final result = getAiMove(game);

          expect(result, 8);
        });
      });

      group('blocks opponent winning move', () {
        test('blocks horizontal winning threat', () {
          // X X .   -> AI should block at index 2
          // O . .
          // . . .
          final board = Board.fromCells([
            Player.x,
            Player.x,
            Player.none,
            Player.o,
            Player.none,
            Player.none,
            Player.none,
            Player.none,
            Player.none,
          ]);
          final game = Game(
            board: board,
            currentPlayer: Player.o,
            status: GameStatus.inProgress,
            mode: GameMode.playerVsAi,
            difficulty: AiDifficulty.expert,
          );

          final result = getAiMove(game);

          expect(result, 2);
        });

        test('blocks vertical winning threat', () {
          // X O .
          // X . .
          // . . .   -> AI should block at index 6
          final board = Board.fromCells([
            Player.x,
            Player.o,
            Player.none,
            Player.x,
            Player.none,
            Player.none,
            Player.none,
            Player.none,
            Player.none,
          ]);
          final game = Game(
            board: board,
            currentPlayer: Player.o,
            status: GameStatus.inProgress,
            mode: GameMode.playerVsAi,
            difficulty: AiDifficulty.expert,
          );

          final result = getAiMove(game);

          expect(result, 6);
        });

        test('blocks diagonal winning threat', () {
          // X . .
          // . X .
          // . . .   -> AI should block at index 8
          final board = Board.fromCells([
            Player.x,
            Player.none,
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
            mode: GameMode.playerVsAi,
            difficulty: AiDifficulty.expert,
          );

          final result = getAiMove(game);

          expect(result, 8);
        });
      });

      group('prefers center', () {
        test('takes center when available and no immediate win/block', () {
          // X . .
          // . . .
          // . . .   -> AI should take center (4)
          final board = Board.fromCells([
            Player.x,
            Player.none,
            Player.none,
            Player.none,
            Player.none,
            Player.none,
            Player.none,
            Player.none,
            Player.none,
          ]);
          final game = Game(
            board: board,
            currentPlayer: Player.o,
            status: GameStatus.inProgress,
            mode: GameMode.playerVsAi,
            difficulty: AiDifficulty.expert,
          );

          final result = getAiMove(game);

          expect(result, 4);
        });
      });

      group('prefers corners', () {
        test('takes corner when center occupied and no win/block', () {
          // . . .
          // . X .
          // . . .   -> AI should take a corner (0, 2, 6, or 8)
          final board = Board.fromCells([
            Player.none,
            Player.none,
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
            mode: GameMode.playerVsAi,
            difficulty: AiDifficulty.expert,
          );

          final result = getAiMove(game);

          expect(result, isIn([0, 2, 6, 8]));
        });
      });

      group('prioritizes winning over blocking', () {
        test('chooses win over block when both available', () {
          // X X .   -> X threatens to win at 2
          // O O .   -> O can win at 5
          // . . .
          final board = Board.fromCells([
            Player.x,
            Player.x,
            Player.none,
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
            mode: GameMode.playerVsAi,
            difficulty: AiDifficulty.expert,
          );

          final result = getAiMove(game);

          expect(result, 5); // Win takes priority over block
        });
      });
    });
  });
}
