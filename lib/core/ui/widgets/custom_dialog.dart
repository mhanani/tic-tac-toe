import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const CustomDialog({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
  }
}
