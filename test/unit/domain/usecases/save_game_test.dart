import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tic_tac_toe/core/error/failures.dart';
import 'package:tic_tac_toe/features/game/domain/entities/entities.dart';
import 'package:tic_tac_toe/features/game/domain/usecases/save_game.dart';

import '../../../mocks/mocks.dart';

void main() {
  late SaveGame saveGame;
  late MockGameRepository mockRepository;

  setUpAll(() {
    registerFallbackValues();
  });

  setUp(() {
    mockRepository = MockGameRepository();
    saveGame = SaveGame(mockRepository);
  });

  group('SaveGame', () {
    test('calls repository.saveGame with correct game', () async {
      final game = Game.initial();
      when(
        () => mockRepository.saveGame(any()),
      ).thenAnswer((_) async => const Right(unit));
      when(
        () => mockRepository.saveScores(
          xWins: any(named: 'xWins'),
          oWins: any(named: 'oWins'),
          draws: any(named: 'draws'),
        ),
      ).thenAnswer((_) async => const Right(unit));

      await saveGame(game);

      verify(() => mockRepository.saveGame(game)).called(1);
    });

    test('calls repository.saveScores with correct values', () async {
      final game = Game(
        board: Board.empty(),
        currentPlayer: Player.x,
        status: GameStatus.inProgress,
        mode: GameMode.playerVsPlayer,
        xWins: 5,
        oWins: 3,
        draws: 2,
      );
      when(
        () => mockRepository.saveGame(any()),
      ).thenAnswer((_) async => const Right(unit));
      when(
        () => mockRepository.saveScores(
          xWins: any(named: 'xWins'),
          oWins: any(named: 'oWins'),
          draws: any(named: 'draws'),
        ),
      ).thenAnswer((_) async => const Right(unit));

      await saveGame(game);

      verify(
        () => mockRepository.saveScores(xWins: 5, oWins: 3, draws: 2),
      ).called(1);
    });

    test('returns failure when saveGame fails', () async {
      final game = Game.initial();
      const failure = CacheFailure(message: 'Failed to save game');

      when(
        () => mockRepository.saveGame(any()),
      ).thenAnswer((_) async => const Left(failure));

      final result = await saveGame(game);

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f.message, 'Failed to save game'),
        (_) => fail('Should be Left'),
      );
    });

    test('returns failure when saveScores fails', () async {
      final game = Game.initial();
      const failure = CacheFailure(message: 'Failed to save scores');

      when(
        () => mockRepository.saveGame(any()),
      ).thenAnswer((_) async => const Right(unit));
      when(
        () => mockRepository.saveScores(
          xWins: any(named: 'xWins'),
          oWins: any(named: 'oWins'),
          draws: any(named: 'draws'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await saveGame(game);

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f.message, 'Failed to save scores'),
        (_) => fail('Should be Left'),
      );
    });

    test('returns Right(unit) on success', () async {
      final game = Game.initial();

      when(
        () => mockRepository.saveGame(any()),
      ).thenAnswer((_) async => const Right(unit));
      when(
        () => mockRepository.saveScores(
          xWins: any(named: 'xWins'),
          oWins: any(named: 'oWins'),
          draws: any(named: 'draws'),
        ),
      ).thenAnswer((_) async => const Right(unit));

      final result = await saveGame(game);

      expect(result.isRight(), true);
    });
  });
}
