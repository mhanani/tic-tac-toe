import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tic_tac_toe/core/extensions/extensions.dart';
import 'package:tic_tac_toe/core/router/app_router.dart';
import 'package:tic_tac_toe/core/theme/app_theme.dart';

/// Page displayed when a route is not found
class UnknownPage extends StatelessWidget {
  final String? path;

  const UnknownPage({super.key, this.path});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
                Text(l10n.pageNotFound, style: AppTheme.headingLarge),
                const SizedBox(height: AppTheme.spacingSm),
                if (path != null)
                  Text(
                    l10n.pageNotFoundMessage(path!),
                    style: AppTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: AppTheme.spacingXl),
                ElevatedButton.icon(
                  onPressed: () => context.go(AppRoutes.home),
                  icon: const Icon(Icons.home),
                  label: Text(l10n.goHome),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
