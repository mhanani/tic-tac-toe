import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tic_tac_toe/app.dart';
import 'package:tic_tac_toe/core/observer/app_provider_observer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      observers: [AppProviderObserver()],
      child: const AppLoader(),
    ),
  );
}
