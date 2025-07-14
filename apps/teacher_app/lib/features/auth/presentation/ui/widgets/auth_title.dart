import 'package:flutter/material.dart';
import '../../../../../core/responsive_widgets.dart';

/// Widget متجاوب لعناوين المصادقة
class AuthTitle extends StatelessWidget {
  final String text;
  final Color? color;
  final double? mobileSize;
  final double? tabletSize;
  final double? desktopSize;

  const AuthTitle(
    this.text, {
    super.key,
    this.color,
    this.mobileSize,
    this.tabletSize,
    this.desktopSize,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveText(
      text,
      mobileSize: mobileSize ?? 24,
      tabletSize: tabletSize ?? 28,
      desktopSize: desktopSize ?? 32,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: color ?? Theme.of(context).primaryColor,
      ),
      textAlign: TextAlign.center,
    );
  }
} 