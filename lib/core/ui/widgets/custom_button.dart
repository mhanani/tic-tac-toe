import 'package:flutter/material.dart';

import 'package:tic_tac_toe/core/theme/app_theme.dart';
import 'package:tic_tac_toe/core/ui/widgets/custom_icon.dart';
import 'package:tic_tac_toe/core/ui/widgets/loading.dart';

enum ButtonVariant { primary, secondary, text }

enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? iconData;
  final String? iconAssetPath;
  final bool iconLeading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final bool expanded;
  final String? tooltip;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.iconData,
    this.iconAssetPath,
    this.iconLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.expanded = false,
    this.tooltip,
  });

  const CustomButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.iconData,
    this.iconAssetPath,
    this.iconLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.expanded = false,
    this.tooltip,
  }) : variant = ButtonVariant.primary,
       borderColor = null;

  const CustomButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.iconData,
    this.iconAssetPath,
    this.iconLeading = true,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.expanded = false,
    this.tooltip,
  }) : variant = ButtonVariant.secondary,
       backgroundColor = null;

  const CustomButton.text({
    super.key,
    required this.label,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.iconData,
    this.iconAssetPath,
    this.iconLeading = true,
    this.foregroundColor,
    this.padding,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.expanded = false,
    this.tooltip,
  }) : variant = ButtonVariant.text,
       backgroundColor = null,
       borderColor = null,
       borderRadius = null;

  bool get _isEnabled => onPressed != null && !isDisabled && !isLoading;
  bool get _hasIcon => iconData != null || iconAssetPath != null;

  double get _iconSize => switch (size) {
    ButtonSize.small => 18.0,
    ButtonSize.medium => 22.0,
    ButtonSize.large => 26.0,
  };

  EdgeInsetsGeometry get _defaultPadding => switch (size) {
    ButtonSize.small => const EdgeInsets.symmetric(
      horizontal: AppTheme.spacingMd,
      vertical: AppTheme.spacingSm,
    ),
    ButtonSize.medium => const EdgeInsets.symmetric(
      horizontal: AppTheme.spacingLg,
      vertical: AppTheme.spacingMd,
    ),
    ButtonSize.large => const EdgeInsets.symmetric(
      horizontal: AppTheme.spacingXl,
      vertical: AppTheme.spacingMd + 4,
    ),
  };

  TextStyle get _labelStyle => switch (size) {
    ButtonSize.small => AppTheme.bodyMedium.copyWith(
      fontWeight: FontWeight.w600,
    ),
    ButtonSize.medium => AppTheme.labelLarge,
    ButtonSize.large => AppTheme.labelLarge.copyWith(fontSize: 18),
  };

  @override
  Widget build(BuildContext context) {
    Widget button = switch (variant) {
      ButtonVariant.primary => _buildPrimary(),
      ButtonVariant.secondary => _buildSecondary(),
      ButtonVariant.text => _buildText(),
    };

    if (width != null) {
      button = SizedBox(width: width, child: button);
    } else if (expanded) {
      button = SizedBox(width: double.infinity, child: button);
    }

    if (tooltip != null) {
      button = Tooltip(message: tooltip!, child: button);
    }

    return button;
  }

  Widget? _buildIcon(Color color) {
    if (isLoading) {
      return Loading(
        inline: true,
        size: _iconSize,
        strokeWidth: 2.0,
        color: color,
      );
    }
    if (iconData != null) {
      return CustomIcon(iconData: iconData, size: _iconSize, color: color);
    }
    if (iconAssetPath != null) {
      return CustomIcon(
        assetPath: iconAssetPath,
        size: _iconSize,
        color: color,
      );
    }
    return null;
  }

  Widget _buildPrimary() {
    final bgColor = backgroundColor ?? AppTheme.primaryColor;
    final fgColor = foregroundColor ?? AppTheme.textPrimary;
    final icon = _buildIcon(fgColor);
    final radius = borderRadius ?? AppTheme.radiusMd;

    Widget buttonContent;
    if (icon != null && _hasIcon) {
      buttonContent = iconLeading
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                const SizedBox(width: AppTheme.spacingSm),
                Text(label, style: _labelStyle.copyWith(color: fgColor)),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: _labelStyle.copyWith(color: fgColor)),
                const SizedBox(width: AppTheme.spacingSm),
                icon,
              ],
            );
    } else {
      buttonContent = isLoading
          ? Loading(
              inline: true,
              size: _iconSize,
              strokeWidth: 2.0,
              color: fgColor,
            )
          : Text(label, style: _labelStyle.copyWith(color: fgColor));
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _isEnabled
              ? [bgColor, bgColor.withValues(alpha: 0.8)]
              : [
                  bgColor.withValues(alpha: 0.5),
                  bgColor.withValues(alpha: 0.4),
                ],
        ),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: _isEnabled
            ? [
                BoxShadow(
                  color: bgColor.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(radius),
          splashColor: Colors.white.withValues(alpha: 0.2),
          highlightColor: Colors.white.withValues(alpha: 0.1),
          child: Padding(
            padding: padding ?? _defaultPadding,
            child: Center(child: buttonContent),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondary() {
    final fgColor = foregroundColor ?? AppTheme.textPrimary;
    final bdColor = borderColor ?? AppTheme.textSecondary;
    final icon = _buildIcon(fgColor);

    final style = OutlinedButton.styleFrom(
      foregroundColor: fgColor,
      disabledForegroundColor: fgColor.withValues(alpha: 0.5),
      side: BorderSide(
        color: _isEnabled ? bdColor : bdColor.withValues(alpha: 0.5),
      ),
      padding: padding ?? _defaultPadding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? AppTheme.radiusMd),
      ),
      textStyle: _labelStyle,
    );

    if (icon != null && _hasIcon) {
      return iconLeading
          ? OutlinedButton.icon(
              onPressed: _isEnabled ? onPressed : null,
              style: style,
              icon: icon,
              label: Text(label),
            )
          : OutlinedButton(
              onPressed: _isEnabled ? onPressed : null,
              style: style,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label),
                  const SizedBox(width: AppTheme.spacingSm),
                  icon,
                ],
              ),
            );
    }

    return OutlinedButton(
      onPressed: _isEnabled ? onPressed : null,
      style: style,
      child: isLoading
          ? Loading(
              inline: true,
              size: _iconSize,
              strokeWidth: 2.0,
              color: fgColor,
            )
          : Text(label),
    );
  }

  Widget _buildText() {
    final fgColor = foregroundColor ?? AppTheme.primaryColor;
    final icon = _buildIcon(fgColor);

    final style = TextButton.styleFrom(
      foregroundColor: fgColor,
      disabledForegroundColor: fgColor.withValues(alpha: 0.5),
      padding: padding ?? _defaultPadding,
      textStyle: _labelStyle,
    );

    if (icon != null && _hasIcon) {
      return iconLeading
          ? TextButton.icon(
              onPressed: _isEnabled ? onPressed : null,
              style: style,
              icon: icon,
              label: Text(label),
            )
          : TextButton(
              onPressed: _isEnabled ? onPressed : null,
              style: style,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label),
                  const SizedBox(width: AppTheme.spacingSm),
                  icon,
                ],
              ),
            );
    }

    return TextButton(
      onPressed: _isEnabled ? onPressed : null,
      style: style,
      child: isLoading
          ? Loading(
              inline: true,
              size: _iconSize,
              strokeWidth: 2.0,
              color: fgColor,
            )
          : Text(label),
    );
  }
}
