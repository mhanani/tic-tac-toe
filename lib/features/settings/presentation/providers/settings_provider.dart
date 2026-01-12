import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tic_tac_toe/core/providers/shared_prefs_provider.dart';
import 'package:tic_tac_toe/core/utils/logger.dart';
import 'package:tic_tac_toe/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:tic_tac_toe/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:tic_tac_toe/features/settings/domain/entities/app_locale.dart';
import 'package:tic_tac_toe/features/settings/domain/repositories/settings_repository.dart';

part 'settings_provider.g.dart';

/// Provider for the settings local data source
@Riverpod(keepAlive: true)
SettingsLocalDataSource settingsLocalDataSource(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsLocalDataSource(prefs);
}

/// Provider for the settings repository
@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) {
  final dataSource = ref.watch(settingsLocalDataSourceProvider);
  return SettingsRepositoryImpl(dataSource);
}

/// Notifier for locale state
@Riverpod(keepAlive: true)
class LocaleNotifier extends _$LocaleNotifier {
  @override
  AppLocale build() {
    final repository = ref.watch(settingsRepositoryProvider);
    final result = repository.getLocale();

    return result.fold((failure) {
      logger.e(
        'Failed to get locale: ${failure.message}',
        tag: 'SettingsProvider',
      );
      return AppLocale.system; // Default fallback
    }, (locale) => locale);
  }

  /// Set the app locale
  Future<void> setLocale(AppLocale locale) async {
    final repository = ref.read(settingsRepositoryProvider);
    final result = await repository.saveLocale(locale);

    result.fold(
      (failure) {
        logger.e(
          'Failed to save locale: ${failure.message}',
          tag: 'SettingsProvider',
        );
      },
      (_) {
        state = locale;
      },
    );
  }
}

/// Provider for the actual Locale to use in MaterialApp
@Riverpod(keepAlive: true)
Locale? appLocale(Ref ref) {
  final appLocale = ref.watch(localeProvider);
  return appLocale.toLocale();
}
