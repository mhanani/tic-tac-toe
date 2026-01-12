import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tic_tac_toe/core/error/failures.dart';
import 'package:tic_tac_toe/features/game/domain/entities/entities.dart';
import 'package:tic_tac_toe/features/game/domain/usecases/load_game.dart';

import '../../../mocks/mocks.dart';

void main() {
  late LoadGame loadGame;
  late MockGameRepository mockRepository;

  setUpAll(() {
    registerFallbackValues();
  });

  setUp(() {
    mockRepository = MockGameRepository();
    loadGame = LoadGame(mockRepository);
  });

  group('LoadGame', () {
    test('calls repository.loadGame', () async {
      when(
        () => mockRepository.loadGame(),
      ).thenAnswer((_) async => const Right(null));

      await loadGame();

      verify(() => mockRepository.loadGame()).called(1);
    });

    test('returns Right(null) when no saved game exists', () async {
      when(
        () => mockRepository.loadGame(),
      ).thenAnswer((_) async => const Right(null));

      final result = await loadGame();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should be Right'),
        (game) => expect(game, isNull),
      );
    });

    test('returns game with scores merged when saved game exists', () async {
      final savedGame = Game(
        board: Board.empty().makeMove(0, Player.x),
        currentPlayer: Player.o,
        status: GameStatus.inProgress,
        mode: GameMode.playerVsPlayer,
        xWins: 0,
        oWins: 0,
        draws: 0,
      );

      when(
        () => mockRepository.loadGame(),
      ).thenAnswer((_) async => Right(savedGame));
      when(
        () => mockRepository.loadScores(),
      ).thenAnswer((_) async => const Right((xWins: 5, oWins: 3, draws: 2)));

      final result = await loadGame();

      expect(result.isRight(), true);
      result.fold((_) => fail('Should be Right'), (game) {
        expect(game, isNotNull);
        expect(game!.board.getCell(0), Player.x);
        expect(game.currentPlayer, Player.o);
        expect(game.status, GameStatus.inProgress);
        expect(game.xWins, 5);
        expect(game.oWins, 3);
        expect(game.draws, 2);
      });
    });

    test('calls repository.loadScores when game exists', () async {
      final savedGame = Game.initial();

      when(
        () => mockRepository.loadGame(),
      ).thenAnswer((_) async => Right(savedGame));
      when(
        () => mockRepository.loadScores(),
      ).thenAnswer((_) async => const Right((xWins: 0, oWins: 0, draws: 0)));

      await loadGame();

      verify(() => mockRepository.loadScores()).called(1);
    });

    test('does not call loadScores when no game exists', () async {
      when(
        () => mockRepository.loadGame(),
      ).thenAnswer((_) async => const Right(null));

      await loadGame();

      verifyNever(() => mockRepository.loadScores());
    });

    test('preserves game mode from saved game', () async {
      final savedGame = Game.initial(
        mode: GameMode.playerVsAi,
        difficulty: AiDifficulty.expert,
      );

      when(
        () => mockRepository.loadGame(),
      ).thenAnswer((_) async => Right(savedGame));
      when(
        () => mockRepository.loadScores(),
      ).thenAnswer((_) async => const Right((xWins: 1, oWins: 2, draws: 1)));

      final result = await loadGame();

      result.fold((_) => fail('Should be Right'), (game) {
        expect(game!.mode, GameMode.playerVsAi);
        expect(game.difficulty, AiDifficulty.expert);
      });
    });

    test('preserves board state from saved game', () async {
      var board = Board.empty();
      board = board.makeMove(0, Player.x);
      board = board.makeMove(4, Player.o);
      board = board.makeMove(8, Player.x);

      final savedGame = Game(
        board: board,
        currentPlayer: Player.o,
        status: GameStatus.inProgress,
        mode: GameMode.playerVsPlayer,
      );

      when(
        () => mockRepository.loadGame(),
      ).thenAnswer((_) async => Right(savedGame));
      when(
        () => mockRepository.loadScores(),
      ).thenAnswer((_) async => const Right((xWins: 0, oWins: 0, draws: 0)));

      final result = await loadGame();

      result.fold((_) => fail('Should be Right'), (game) {
        expect(game!.board.getCell(0), Player.x);
        expect(game.board.getCell(4), Player.o);
        expect(game.board.getCell(8), Player.x);
      });
    });

    test('returns failure when loadGame fails', () async {
      const failure = CacheFailure(message: 'Failed to load game');

      when(
        () => mockRepository.loadGame(),
      ).thenAnswer((_) async => const Left(failure));

      final result = await loadGame();

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f.message, 'Failed to load game'),
        (_) => fail('Should be Left'),
      );
    });

    test('returns failure when loadScores fails', () async {
      final savedGame = Game.initial();
      const failure = CacheFailure(message: 'Failed to load scores');

      when(
        () => mockRepository.loadGame(),
      ).thenAnswer((_) async => Right(savedGame));
      when(
        () => mockRepository.loadScores(),
      ).thenAnswer((_) async => const Left(failure));

      final result = await loadGame();

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f.message, 'Failed to load scores'),
        (_) => fail('Should be Left'),
      );
    });
  });
}
