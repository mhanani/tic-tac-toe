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

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: _isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(radius),
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
                    if (subtitle != null)
                      Text(subtitle!, style: AppTheme.bodyMedium),
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
                const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(Color color) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingSm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
      child: iconData != null
          ? CustomIcon(iconData: iconData, size: 28, color: color)
          : CustomIcon(assetPath: iconAssetPath, size: 28, color: color),
    );
  }
}
