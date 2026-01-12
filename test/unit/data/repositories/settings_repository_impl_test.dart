import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tic_tac_toe/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:tic_tac_toe/features/settings/domain/entities/app_locale.dart';

import '../../../mocks/mocks.dart';

void main() {
  late SettingsRepositoryImpl repository;
  late MockSettingsLocalDataSource mockDataSource;

  setUpAll(() {
    registerFallbackValue(AppLocale.system);
  });

  setUp(() {
    mockDataSource = MockSettingsLocalDataSource();
    repository = SettingsRepositoryImpl(mockDataSource);
  });

  group('SettingsRepositoryImpl', () {
    group('getLocale', () {
      test('returns AppLocale.system when data source returns system', () {
        when(() => mockDataSource.getLocale()).thenReturn(AppLocale.system);

        final result = repository.getLocale();

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should be Right'),
          (locale) => expect(locale, AppLocale.system),
        );
      });

      test('returns AppLocale.en when data source returns en', () {
        when(() => mockDataSource.getLocale()).thenReturn(AppLocale.en);

        final result = repository.getLocale();

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should be Right'),
          (locale) => expect(locale, AppLocale.en),
        );
      });

      test('returns AppLocale.fr when data source returns fr', () {
        when(() => mockDataSource.getLocale()).thenReturn(AppLocale.fr);

        final result = repository.getLocale();

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should be Right'),
          (locale) => expect(locale, AppLocale.fr),
        );
      });

      test('returns Left on exception', () {
        when(
          () => mockDataSource.getLocale(),
        ).thenThrow(Exception('Storage error'));

        final result = repository.getLocale();

        expect(result.isLeft(), true);
      });
    });

    group('saveLocale', () {
      test('saves AppLocale.en', () async {
        when(() => mockDataSource.saveLocale(any())).thenAnswer((_) async {});

        final result = await repository.saveLocale(AppLocale.en);

        expect(result.isRight(), true);
        verify(() => mockDataSource.saveLocale(AppLocale.en)).called(1);
      });

      test('saves AppLocale.fr', () async {
        when(() => mockDataSource.saveLocale(any())).thenAnswer((_) async {});

        final result = await repository.saveLocale(AppLocale.fr);

        expect(result.isRight(), true);
        verify(() => mockDataSource.saveLocale(AppLocale.fr)).called(1);
      });

      test('saves AppLocale.system', () async {
        when(() => mockDataSource.saveLocale(any())).thenAnswer((_) async {});

        final result = await repository.saveLocale(AppLocale.system);

        expect(result.isRight(), true);
        verify(() => mockDataSource.saveLocale(AppLocale.system)).called(1);
      });

      test('returns Left on exception', () async {
        when(
          () => mockDataSource.saveLocale(any()),
        ).thenThrow(Exception('Storage error'));

        final result = await repository.saveLocale(AppLocale.en);

        expect(result.isLeft(), true);
      });
    });
  });
}
