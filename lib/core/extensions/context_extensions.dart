import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';

/// Extension on BuildContext for easy access to localization
extension LocalizedBuildContext on BuildContext {
  /// Access localized strings via context.l10n
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
