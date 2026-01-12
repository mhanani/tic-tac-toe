import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tic_tac_toe/core/l10n/app_localizations.dart';

/// Extension on WidgetTester to easily pump a widget with all required wrappers
extension PumpApp on WidgetTester {
  /// Pumps a widget wrapped with MaterialApp and ProviderScope
  ///
  /// [widget] - The widget to test
  /// [overrides] - Optional Riverpod provider overrides
  /// [locale] - Optional locale (defaults to English)
  Future<void> pumpApp(
    Widget widget, {
    List<Object> overrides = const [],
    Locale locale = const Locale('en'),
  }) async {
    await pumpWidget(
      ProviderScope(
        overrides: overrides.cast(),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          home: widget,
        ),
      ),
    );
    await pump();
  }

  /// Pumps a widget wrapped with MaterialApp and ProviderScope inside a Scaffold
  ///
  /// Useful for testing widgets that need to be inside a Scaffold
  Future<void> pumpAppWithScaffold(
    Widget widget, {
    List<Object> overrides = const [],
    Locale locale = const Locale('en'),
  }) async {
    await pumpApp(
      Scaffold(body: widget),
      overrides: overrides,
      locale: locale,
    );
  }
}
