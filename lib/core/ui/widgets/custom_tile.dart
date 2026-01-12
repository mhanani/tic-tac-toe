import 'package:flutter/material.dart';

import 'package:tic_tac_toe/core/theme/app_theme.dart';
import 'package:tic_tac_toe/core/ui/widgets/custom_icon.dart';
import 'package:tic_tac_toe/core/ui/widgets/loading.dart';

class CustomTile extends StatelessWidget {
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;
  final IconData? iconData;
  final String? iconAssetPath;
  final bool showChevron;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const CustomTile({
    super.key,
    required this.label,
    this.subtitle,
    this.onTap,
    this.iconData,
    this.iconAssetPath,
    this.showChevron = false,
    this.isLoading = false,
    this.backgroundColor,
    this.iconColor,
    this.borderRadius,
    this.padding,
  });

  bool get _isEnabled => onTap != null && !isLoading;
  bool get _hasIcon => iconData != null || iconAssetPath != null;

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppTheme.cardColor;
    final fgColor = iconColor ?? AppTheme.primaryColor;
    final radius = borderRadius ?? AppTheme.radiusMd;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            bgColor.withValues(alpha: 0.8),
            bgColor.withValues(alpha: 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: AppTheme.surfaceColor.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isEnabled ? onTap : null,
          borderRadius: BorderRadius.circular(radius),
          splashColor: fgColor.withValues(alpha: 0.1),
          highlightColor: fgColor.withValues(alpha: 0.05),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppTheme.spacingMd),
            child: Row(
              children: [
                if (_hasIcon) ...[
                  _buildLeadingIcon(fgColor),
                  const SizedBox(width: AppTheme.spacingMd),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: AppTheme.headingSmall.copyWith(
                          color: _isEnabled ? null : AppTheme.textSecondary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(subtitle!, style: AppTheme.bodyMedium),
                      ],
                    ],
                  ),
                ),
                if (isLoading)
                  const Loading(
                    inline: true,
                    size: 20,
                    strokeWidth: 2.0,
                    color: AppTheme.textSecondary,
                  )
                else if (showChevron)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    child: const Icon(
                      Icons.chevron_right,
                      color: AppTheme.textSecondary,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(Color color) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingSm + 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.25),
            color.withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: iconData != null
          ? CustomIcon(iconData: iconData, size: 26, color: color)
          : CustomIcon(assetPath: iconAssetPath, size: 26, color: color),
    );
  }
}
