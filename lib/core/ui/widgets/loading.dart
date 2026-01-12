import 'package:flutter/material.dart';

import 'package:tic_tac_toe/core/theme/app_theme.dart';

/// Reusable loading indicator widget
class Loading extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;
  final double strokeWidth;
  final bool inline;

  const Loading({
    super.key,
    this.message,
    this.size = 32.0,
    this.color,
    this.strokeWidth = 3.0,
    this.inline = false,
  });

  Widget _buildIndicator() {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppTheme.primaryColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // For inline usage (e.g., in a Row), return just the indicator
    if (inline) {
      return _buildIndicator();
    }

    // For centered usage (default behavior)
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIndicator(),
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
