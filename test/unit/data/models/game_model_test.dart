import 'package:flutter_test/flutter_test.dart';

import 'package:tic_tac_toe/features/game/data/models/game_model.dart';
import 'package:tic_tac_toe/features/game/domain/entities/entities.dart';

void main() {
  group('GameModel', () {
    group('toJson', () {
      test('creates valid JSON with all fields', () {
        const model = GameModel(
          board: [0, 1, 2, 2, 0, 2, 2, 2, 1],
          currentPlayer: 1,
          status: 1,
          mode: 0,
          xWins: 5,
          oWins: 3,
          draws: 2,
        );

        final json = model.toJson();

        expect(json['board'], [0, 1, 2, 2, 0, 2, 2, 2, 1]);
        expect(json['currentPlayer'], 1);
        expect(json['status'], 1);
        expect(json['mode'], 0);
        expect(json['xWins'], 5);
        expect(json['oWins'], 3);
        expect(json['draws'], 2);
      });

      test('uses default values for scores when not provided', () {
        const model = GameModel(
          board: [2, 2, 2, 2, 2, 2, 2, 2, 2],
          currentPlayer: 0,
          status: 0,
          mode: 0,
        );

        final json = model.toJson();

        expect(json['xWins'], 0);
        expect(json['oWins'], 0);
        expect(json['draws'], 0);
      });
    });

    group('fromJson', () {
      test('parses JSON correctly', () {
        final json = {
          'board': [0, 1, 2, 2, 0, 2, 2, 2, 1],
          'currentPlayer': 1,
          'status': 2,
          'mode': 1,
          'xWins': 10,
          'oWins': 8,
          'draws': 4,
        };

        final model = GameModel.fromJson(json);

        expect(model.board, [0, 1, 2, 2, 0, 2, 2, 2, 1]);
        expect(model.currentPlayer, 1);
        expect(model.status, 2);
        expect(model.mode, 1);
        expect(model.xWins, 10);
        expect(model.oWins, 8);
        expect(model.draws, 4);
      });

      test('uses default scores when missing from JSON', () {
        final json = {
          'board': [2, 2, 2, 2, 2, 2, 2, 2, 2],
          'currentPlayer': 0,
          'status': 0,
          'mode': 0,
        };

        final model = GameModel.fromJson(json);

        expect(model.xWins, 0);
        expect(model.oWins, 0);
        expect(model.draws, 0);
      });
    });

    group('round-trip conversion', () {
      test('toJson -> fromJson preserves data', () {
        const original = GameModel(
          board: [0, 1, 0, 2, 1, 2, 0, 2, 1],
          currentPlayer: 0,
          status: 1,
          mode: 1,
          xWins: 7,
          oWins: 5,
          draws: 3,
        );

        final json = original.toJson();
        final restored = GameModel.fromJson(json);

        expect(restored.board, original.board);
        expect(restored.currentPlayer, original.currentPlayer);
        expect(restored.status, original.status);
        expect(restored.mode, original.mode);
        expect(restored.xWins, original.xWins);
        expect(restored.oWins, original.oWins);
        expect(restored.draws, original.draws);
      });
    });
  });

  group('GameModelX extension', () {
    group('toEntity', () {
      test('converts to Game entity correctly', () {
        const model = GameModel(
          board: [0, 1, 2, 2, 0, 2, 2, 2, 1],
          currentPlayer: 1, // Player.o
          status: 1, // inProgress
          mode: 0, // playerVsPlayer
          xWins: 5,
          oWins: 3,
          draws: 2,
        );

        final entity = model.toEntity();

        expect(entity.board.getCell(0), Player.x);
        expect(entity.board.getCell(1), Player.o);
        expect(entity.board.getCell(2), Player.none);
        expect(entity.currentPlayer, Player.o);
        expect(entity.status, GameStatus.inProgress);
        expect(entity.mode, GameMode.playerVsPlayer);
        expect(entity.xWins, 5);
        expect(entity.oWins, 3);
        expect(entity.draws, 2);
      });

      test('converts PlayerVsAi mode correctly', () {
        const model = GameModel(
          board: [2, 2, 2, 2, 2, 2, 2, 2, 2],
          currentPlayer: 0,
          status: 1,
          mode: 1, // playerVsAi
        );

        final entity = model.toEntity();

        expect(entity.mode, GameMode.playerVsAi);
      });

      test('converts all game statuses correctly', () {
        for (var i = 0; i < GameStatus.values.length; i++) {
          final model = GameModel(
            board: [2, 2, 2, 2, 2, 2, 2, 2, 2],
            currentPlayer: 0,
            status: i,
            mode: 0,
          );

          final entity = model.toEntity();

          expect(entity.status, GameStatus.values[i]);
        }
      });
    });
  });

  group('GameX extension', () {
    group('toModel', () {
      test('converts Game entity to model correctly', () {
        final game = Game(
          board: Board.fromCells([
            Player.x,
            Player.o,
            Player.none,
            Player.none,
            Player.x,
            Player.none,
            Player.none,
            Player.none,
            Player.o,
          ]),
          currentPlayer: Player.o,
          status: GameStatus.inProgress,
          mode: GameMode.playerVsPlayer,
          xWins: 10,
          oWins: 8,
          draws: 5,
        );

        final model = game.toModel();

        expect(model.board, [0, 1, 2, 2, 0, 2, 2, 2, 1]);
        expect(model.currentPlayer, 1); // Player.o
        expect(model.status, 1); // inProgress
        expect(model.mode, 0); // playerVsPlayer
        expect(model.xWins, 10);
        expect(model.oWins, 8);
        expect(model.draws, 5);
      });

      test('converts PlayerVsAi mode correctly', () {
        final game = Game.initial(mode: GameMode.playerVsAi);

        final model = game.toModel();

        expect(model.mode, 1);
      });
    });

    group('round-trip conversion', () {
      test('Game -> Model -> Game preserves data', () {
        final original = Game(
          board: Board.fromCells([
            Player.x,
            Player.o,
            Player.x,
            Player.none,
            Player.o,
            Player.none,
            Player.x,
            Player.none,
            Player.o,
          ]),
          currentPlayer: Player.x,
          status: GameStatus.inProgress,
          mode: GameMode.playerVsAi,
          xWins: 15,
          oWins: 12,
          draws: 8,
        );

        final model = original.toModel();
        final restored = model.toEntity();

        expect(restored.board, original.board);
        expect(restored.currentPlayer, original.currentPlayer);
        expect(restored.status, original.status);
        expect(restored.mode, original.mode);
        expect(restored.xWins, original.xWins);
        expect(restored.oWins, original.oWins);
        expect(restored.draws, original.draws);
      });
    });
  });
}
