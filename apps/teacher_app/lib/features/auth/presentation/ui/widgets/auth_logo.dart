import 'package:flutter/material.dart';
import '../../../../../core/responsive/responsive_widgets.dart';

/// Widget متجاوب لشعار المصادقة
class AuthLogo extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double? mobileSize;
  final double? tabletSize;
  final double? desktopSize;

  const AuthLogo(
    this.icon, {
    super.key,
    this.color,
    this.mobileSize,
    this.tabletSize,
    this.desktopSize,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveIcon(
      icon,
      mobileSize: mobileSize ?? 80,
      tabletSize: tabletSize ?? 100,
      desktopSize: desktopSize ?? 120,
      color: color ?? Theme.of(context).primaryColor,
    );
  }
} 