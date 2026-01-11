import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tic_tac_toe/features/game/presentation/providers/game_provider.dart';
import 'package:tic_tac_toe/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:tic_tac_toe/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:tic_tac_toe/features/settings/domain/entities/app_locale.dart';
import 'package:tic_tac_toe/features/settings/domain/repositories/settings_repository.dart';

part 'settings_provider.g.dart';

/// Provider for the settings local data source
@Riverpod(keepAlive: true)
SettingsLocalDataSource settingsLocalDataSource(
  SettingsLocalDataSourceRef ref,
) {
  final prefs = ref.watch(sharedPreferencesProvider).requireValue;
  return SettingsLocalDataSource(prefs);
}

/// Provider for the settings repository
@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  final dataSource = ref.watch(settingsLocalDataSourceProvider);
  return SettingsRepositoryImpl(dataSource);
}

/// Notifier for locale state
@Riverpod(keepAlive: true)
class LocaleNotifier extends _$LocaleNotifier {
  @override
  AppLocale build() {
    final repository = ref.watch(settingsRepositoryProvider);
    return repository.getLocale();
  }

  /// Set the app locale
  Future<void> setLocale(AppLocale locale) async {
    final repository = ref.read(settingsRepositoryProvider);
    await repository.saveLocale(locale);
    state = locale;
  }
}

/// Provider for the actual Locale to use in MaterialApp
@Riverpod(keepAlive: true)
Locale? appLocale(AppLocaleRef ref) {
  final appLocale = ref.watch(localeNotifierProvider);
  return appLocale.toLocale();
}
