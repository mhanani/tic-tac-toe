import 'dart:ui';

import 'package:tic_tac_toe/core/extensions/extensions.dart';
import 'package:flutter/widgets.dart' show BuildContext;

/// Represents the available app locales
enum AppLocale {
  system,
  en,
  fr;

  /// Convert to Flutter Locale (null means follow system)
  Locale? toLocale() => switch (this) {
    AppLocale.system => null,
    AppLocale.en => const Locale('en'),
    AppLocale.fr => const Locale('fr'),
  };

  /// Get localized display name
  String localizedName(BuildContext context) => switch (this) {
    AppLocale.system => context.l10n.systemDefault,
    AppLocale.en => context.l10n.english,
    AppLocale.fr => context.l10n.french,
  };

  /// Create from string (for persistence)
  static AppLocale fromString(String? value) => switch (value) {
    'en' => AppLocale.en,
    'fr' => AppLocale.fr,
    _ => AppLocale.system,
  };
}
