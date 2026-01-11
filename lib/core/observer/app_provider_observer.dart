import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tic_tac_toe/core/utils/logger.dart';

/// Provider observer that logs state changes
final class AppProviderObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    logger.d(
      '${context.provider.name ?? context.provider.runtimeType} updated',
      tag: 'Provider',
    );
  }

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    logger.d(
      '${context.provider.name ?? context.provider.runtimeType} created',
      tag: 'Provider',
    );
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    logger.d(
      '${context.provider.name ?? context.provider.runtimeType} disposed',
      tag: 'Provider',
    );
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    logger.e(
      '${context.provider.name ?? context.provider.runtimeType} failed',
      tag: 'Provider',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
