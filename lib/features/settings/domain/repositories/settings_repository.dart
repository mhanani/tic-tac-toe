import 'package:dartz/dartz.dart';
import 'package:tic_tac_toe/core/error/failures.dart';
import 'package:tic_tac_toe/features/settings/domain/entities/app_locale.dart';

/// Abstract repository for settings operations
abstract class SettingsRepository {
  Either<Failure, AppLocale> getLocale();
  Future<Either<Failure, Unit>> saveLocale(AppLocale locale);
}
