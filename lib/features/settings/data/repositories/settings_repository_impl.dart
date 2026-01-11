import 'package:tic_tac_toe/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:tic_tac_toe/features/settings/domain/entities/app_locale.dart';
import 'package:tic_tac_toe/features/settings/domain/repositories/settings_repository.dart';

/// Implementation of SettingsRepository using local data source
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _dataSource;

  SettingsRepositoryImpl(this._dataSource);

  @override
  AppLocale getLocale() => _dataSource.getLocale();

  @override
  Future<void> saveLocale(AppLocale locale) => _dataSource.saveLocale(locale);
}
