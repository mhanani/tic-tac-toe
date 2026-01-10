import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/app_router.dart';
import '../../theme/app_theme.dart';

/// Page displayed when a route is not found
class UnknownPage extends StatelessWidget {
  final String? path;

  const UnknownPage({
    super.key,
    this.path,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.explore_off,
                  size: 80,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(height: AppTheme.spacingLg),
                const Text(
                  'Page Not Found',
                  style: AppTheme.headingLarge,
                ),
                const SizedBox(height: AppTheme.spacingSm),
                if (path != null)
                  Text(
                    'The page "$path" does not exist.',
                    style: AppTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: AppTheme.spacingXl),
                ElevatedButton.icon(
                  onPressed: () => context.go(AppRoutes.home),
                  icon: const Icon(Icons.home),
                  label: const Text('Go Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
