import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tic_tac_toe/app.dart';
import 'package:tic_tac_toe/core/observer/app_provider_observer.dart';
import 'package:tic_tac_toe/core/providers/shared_prefs_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-initialize SharedPreferences before runApp (No async providers leaking everywhere)
  final sharedPrefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      observers: [AppProviderObserver()],
      overrides: [
        // Override the provider with the pre-initialized instance
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
      ],
      child: const TicTacToeApp(),
    ),
  );
}
