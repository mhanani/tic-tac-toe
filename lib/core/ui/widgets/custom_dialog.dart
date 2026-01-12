import 'package:flutter/material.dart';

import 'package:tic_tac_toe/core/theme/app_theme.dart';
import 'package:tic_tac_toe/core/ui/animations/animations.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final AnimationType animationType;
  final Duration? animationDuration;

  const CustomDialog({
    super.key,
    required this.title,
    required this.children,
    this.animationType = AnimationType.fadeIn,
    this.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
    final dialog = Dialog(
      backgroundColor: AppTheme.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: AppTheme.headingSmall),
            const SizedBox(height: AppTheme.spacingMd),
            ...children,
          ],
        ),
      ),
    );

    switch (animationType) {
      case AnimationType.easeOut:
        return CustomEaseOutAnimation(
          duration: animationDuration ?? const Duration(milliseconds: 300),
          child: dialog,
        );
      case AnimationType.fadeIn:
        return CustomFadeInAnimation(
          duration: animationDuration ?? const Duration(milliseconds: 300),
          child: dialog,
        );
      case AnimationType.none:
        return dialog;
    }
  }
}
