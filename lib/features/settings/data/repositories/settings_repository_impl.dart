import 'package:dartz/dartz.dart';

import 'package:tic_tac_toe/core/error/failures.dart';
import 'package:tic_tac_toe/core/utils/logger.dart';
import 'package:tic_tac_toe/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:tic_tac_toe/features/settings/domain/entities/app_locale.dart';
import 'package:tic_tac_toe/features/settings/domain/repositories/settings_repository.dart';

/// Implementation of SettingsRepository using local data source
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _dataSource;

  SettingsRepositoryImpl(this._dataSource);

  @override
  Either<Failure, AppLocale> getLocale() {
    try {
      final locale = _dataSource.getLocale();
      return Right(locale);
    } catch (e, stackTrace) {
      logger.e(
        'Failed to get locale',
        tag: 'SettingsRepository',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        SettingsFailure(
          message: 'Failed to get locale: ${e.toString()}',
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> saveLocale(AppLocale locale) async {
    try {
      await _dataSource.saveLocale(locale);
      return const Right(unit);
    } catch (e, stackTrace) {
      logger.e(
        'Failed to save locale',
        tag: 'SettingsRepository',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        SettingsFailure(
          message: 'Failed to save locale: ${e.toString()}',
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
