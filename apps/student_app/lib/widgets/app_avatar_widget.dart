import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';

class AppAvatarWidget extends StatelessWidget {
  final String imageUrl;
  final bool isBordered;
  final Color borderColor;
  final double radius;
  final double borderThickness;
  final IconData fallbackIcon;
  final Color? iconColor;

  const AppAvatarWidget({
    Key? key,
    required this.imageUrl,
    this.isBordered = false,
    this.borderColor = AppColors.primary,
    this.radius = 20,
    this.borderThickness = 2.0,
    this.fallbackIcon = Icons.person,
    this.iconColor,
  }) : assert(radius >= borderThickness),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color resolvedIconColor = iconColor ?? Colors.white;
    final Widget fallback = Icon(fallbackIcon, color: resolvedIconColor, size: radius);

    Widget child;
    if (imageUrl.trim().isEmpty) {
      child = fallback;
    } else if (imageUrl.startsWith('http')) {
      child = ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.network(
          imageUrl,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Center(child: fallback),
        ),
      );
    } else {
      child = ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(
          imageUrl,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Center(child: fallback),
        ),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: isBordered ? borderColor : Colors.transparent,
      child: CircleAvatar(
        radius: isBordered ? radius - borderThickness : radius,
        backgroundColor: Colors.grey.shade300,
        child: child,
      ),
    );
  }
}
