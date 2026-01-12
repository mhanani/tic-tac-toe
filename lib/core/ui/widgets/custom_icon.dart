import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final IconData? iconData;
  final String? assetPath;
  final double size;
  final Color? color;
  final BoxFit fit;
  final VoidCallback? onTap;
  final String? tooltip;
  final EdgeInsetsGeometry? padding;

  const CustomIcon({
    super.key,
    this.iconData,
    this.assetPath,
    this.size = 24.0,
    this.color,
    this.fit = BoxFit.contain,
    this.onTap,
    this.tooltip,
    this.padding,
  }) : assert(
         iconData != null || assetPath != null,
         'Either iconData or assetPath must be provided',
       );

  const CustomIcon.icon(
    IconData icon, {
    super.key,
    this.size = 24.0,
    this.color,
    this.onTap,
    this.tooltip,
    this.padding,
  }) : iconData = icon,
       assetPath = null,
       fit = BoxFit.contain;

  const CustomIcon.asset(
    String path, {
    super.key,
    this.size = 24.0,
    this.color,
    this.fit = BoxFit.contain,
    this.onTap,
    this.tooltip,
    this.padding,
  }) : assetPath = path,
       iconData = null;

  @override
  Widget build(BuildContext context) {
    Widget icon = _buildIcon(context);

    if (onTap != null) {
      icon = IconButton(
        onPressed: onTap,
        icon: icon,
        padding: padding ?? EdgeInsets.zero,
        constraints: const BoxConstraints(),
        tooltip: tooltip,
      );
    } else if (tooltip != null) {
      icon = Tooltip(message: tooltip!, child: icon);
    }

    return icon;
  }

  Widget _buildIcon(BuildContext context) {
    if (iconData != null) {
      return Icon(iconData, size: size, color: color);
    }

    if (assetPath != null) {
      return Image.asset(
        assetPath!,
        width: size,
        height: size,
        fit: fit,
        color: color,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.broken_image_outlined,
          size: size,
          color: color ?? Theme.of(context).colorScheme.error,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
