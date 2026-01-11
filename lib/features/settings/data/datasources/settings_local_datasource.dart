import 'package:shared_preferences/shared_preferences.dart';

import 'package:tic_tac_toe/features/settings/domain/entities/app_locale.dart';

/// Local data source for settings using SharedPreferences
class SettingsLocalDataSource {
  final SharedPreferences _prefs;

  static const _localeKey = 'app_locale';

  SettingsLocalDataSource(this._prefs);

  /// Get saved locale preference
  AppLocale getLocale() {
    final value = _prefs.getString(_localeKey);
    return AppLocale.fromString(value);
  }

  /// Save locale preference
  Future<void> saveLocale(AppLocale locale) async {
    if (locale == AppLocale.system) {
      await _prefs.remove(_localeKey);
    } else {
      await _prefs.setString(_localeKey, locale.name);
    }
  }
}
