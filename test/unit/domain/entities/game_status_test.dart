import 'package:flutter_test/flutter_test.dart';

import 'package:tic_tac_toe/features/game/domain/entities/game_status.dart';

void main() {
  group('GameStatus', () {
    group('isGameOver', () {
      test('returns true for xWins', () {
        expect(GameStatus.xWins.isGameOver, true);
      });

      test('returns true for oWins', () {
        expect(GameStatus.oWins.isGameOver, true);
      });

      test('returns true for draw', () {
        expect(GameStatus.draw.isGameOver, true);
      });

      test('returns false for inProgress', () {
        expect(GameStatus.inProgress.isGameOver, false);
      });

      test('returns false for notStarted', () {
        expect(GameStatus.notStarted.isGameOver, false);
      });
    });

    group('hasWinner', () {
      test('returns true for xWins', () {
        expect(GameStatus.xWins.hasWinner, true);
      });

      test('returns true for oWins', () {
        expect(GameStatus.oWins.hasWinner, true);
      });

      test('returns false for draw', () {
        expect(GameStatus.draw.hasWinner, false);
      });

      test('returns false for inProgress', () {
        expect(GameStatus.inProgress.hasWinner, false);
      });

      test('returns false for notStarted', () {
        expect(GameStatus.notStarted.hasWinner, false);
      });
    });
  });
}
