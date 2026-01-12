import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tic_tac_toe/features/game/data/models/game_model.dart';
import 'package:tic_tac_toe/features/game/data/repositories/game_repository_impl.dart';
import 'package:tic_tac_toe/features/game/domain/entities/entities.dart';

import '../../../mocks/mocks.dart';

void main() {
  late GameRepositoryImpl repository;
  late MockGameLocalDataSource mockDataSource;

  setUpAll(() {
    registerFallbackValues();
  });

  setUp(() {
    mockDataSource = MockGameLocalDataSource();
    repository = GameRepositoryImpl(mockDataSource);
  });

  group('GameRepositoryImpl', () {
    group('saveGame', () {
      test('delegates to data source with GameModel', () async {
        final game = Game.initial();
        when(() => mockDataSource.saveGame(any())).thenAnswer((_) async {});

        final result = await repository.saveGame(game);

        expect(result.isRight(), true);
        final captured =
            verify(() => mockDataSource.saveGame(captureAny())).captured.single
                as GameModel;
        expect(captured.currentPlayer, game.currentPlayer.index);
        expect(captured.status, game.status.index);
        expect(captured.mode, game.mode.index);
      });

      test('returns Left on exception', () async {
        final game = Game.initial();
        when(
          () => mockDataSource.saveGame(any()),
        ).thenThrow(Exception('Storage error'));

        final result = await repository.saveGame(game);

        expect(result.isLeft(), true);
      });
    });

    group('loadGame', () {
      test('returns entity from data source model', () async {
        final model = GameModel(
          board: [0, 1, 2, 2, 0, 2, 2, 2, 1],
          currentPlayer: 1,
          status: 1,
          mode: 0,
          xWins: 3,
          oWins: 2,
          draws: 1,
        );
        when(() => mockDataSource.loadGame()).thenAnswer((_) async => model);

        final result = await repository.loadGame();

        expect(result.isRight(), true);
        result.fold((_) => fail('Should be Right'), (game) {
          expect(game, isNotNull);
          expect(game!.currentPlayer, Player.o);
          expect(game.status, GameStatus.inProgress);
          expect(game.mode, GameMode.playerVsPlayer);
          expect(game.xWins, 3);
          expect(game.oWins, 2);
          expect(game.draws, 1);
        });
      });

      test('returns Right(null) when no data exists', () async {
        when(() => mockDataSource.loadGame()).thenAnswer((_) async => null);

        final result = await repository.loadGame();

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should be Right'),
          (game) => expect(game, isNull),
        );
      });

      test('returns Left on exception', () async {
        when(
          () => mockDataSource.loadGame(),
        ).thenThrow(Exception('Storage error'));

        final result = await repository.loadGame();

        expect(result.isLeft(), true);
      });
    });

    group('clearGame', () {
      test('delegates to data source', () async {
        when(() => mockDataSource.clearGame()).thenAnswer((_) async {});

        final result = await repository.clearGame();

        expect(result.isRight(), true);
        verify(() => mockDataSource.clearGame()).called(1);
      });

      test('returns Left on exception', () async {
        when(
          () => mockDataSource.clearGame(),
        ).thenThrow(Exception('Storage error'));

        final result = await repository.clearGame();

        expect(result.isLeft(), true);
      });
    });

    group('saveScores', () {
      test('delegates to data source with correct values', () async {
        when(
          () => mockDataSource.saveScores(any(), any(), any()),
        ).thenAnswer((_) async {});

        final result = await repository.saveScores(
          xWins: 5,
          oWins: 3,
          draws: 2,
        );

        expect(result.isRight(), true);
        verify(() => mockDataSource.saveScores(5, 3, 2)).called(1);
      });

      test('returns Left on exception', () async {
        when(
          () => mockDataSource.saveScores(any(), any(), any()),
        ).thenThrow(Exception('Storage error'));

        final result = await repository.saveScores(
          xWins: 5,
          oWins: 3,
          draws: 2,
        );

        expect(result.isLeft(), true);
      });
    });

    group('loadScores', () {
      test('returns scores from data source', () async {
        when(
          () => mockDataSource.loadScores(),
        ).thenAnswer((_) async => (xWins: 10, oWins: 5, draws: 3));

        final result = await repository.loadScores();

        expect(result.isRight(), true);
        result.fold((_) => fail('Should be Right'), (scores) {
          expect(scores.xWins, 10);
          expect(scores.oWins, 5);
          expect(scores.draws, 3);
        });
      });

      test('returns zeros when no scores saved', () async {
        when(
          () => mockDataSource.loadScores(),
        ).thenAnswer((_) async => (xWins: 0, oWins: 0, draws: 0));

        final result = await repository.loadScores();

        expect(result.isRight(), true);
        result.fold((_) => fail('Should be Right'), (scores) {
          expect(scores.xWins, 0);
          expect(scores.oWins, 0);
          expect(scores.draws, 0);
        });
      });

      test('returns Left on exception', () async {
        when(
          () => mockDataSource.loadScores(),
        ).thenThrow(Exception('Storage error'));

        final result = await repository.loadScores();

        expect(result.isLeft(), true);
      });
    });
  });
}
