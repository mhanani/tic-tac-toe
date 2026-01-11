import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tic_tac_toe/core/utils/logger.dart';

/// Provider observer that logs state changes
class AppProviderObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    logger.d(
      '${provider.name ?? provider.runtimeType} updated',
      tag: 'Provider',
    );
  }

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    logger.d(
      '${provider.name ?? provider.runtimeType} created',
      tag: 'Provider',
    );
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    logger.d(
      '${provider.name ?? provider.runtimeType} disposed',
      tag: 'Provider',
    );
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    logger.e(
      '${provider.name ?? provider.runtimeType} failed',
      tag: 'Provider',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
