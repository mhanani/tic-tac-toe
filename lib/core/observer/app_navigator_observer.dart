import 'package:flutter/material.dart';

import '../utils/logger.dart';

/// Navigator observer that logs route changes
class AppNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    logger.d('PUSH: ${route.settings.name ?? route.runtimeType}',
        tag: 'Navigation');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    logger.d('POP: ${route.settings.name ?? route.runtimeType}',
        tag: 'Navigation');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    logger.d(
      'REPLACE: ${oldRoute?.settings.name ?? oldRoute.runtimeType} -> ${newRoute?.settings.name ?? newRoute.runtimeType}',
      tag: 'Navigation',
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    logger.d('REMOVE: ${route.settings.name ?? route.runtimeType}',
        tag: 'Navigation');
  }
}
