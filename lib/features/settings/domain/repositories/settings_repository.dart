import 'package:tic_tac_toe/features/settings/domain/entities/app_locale.dart';

/// Abstract repository for settings operations
abstract class SettingsRepository {
  /// Get the saved locale preference
  AppLocale getLocale();

  /// Save the locale preference
  Future<void> saveLocale(AppLocale locale);
}
