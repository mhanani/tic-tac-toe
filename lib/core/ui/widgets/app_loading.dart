import 'package:flutter/material.dart';

import 'package:tic_tac_toe/core/theme/app_theme.dart';

/// Reusable loading indicator widget
class AppLoading extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;

  const AppLoading({
    super.key,
    this.message,
    this.size = 32.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppTheme.primaryColor,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              message!,
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
