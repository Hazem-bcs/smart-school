import 'package:flutter/material.dart';
import '../../../../../core/responsive/responsive_widgets.dart';

/// Widget متجاوب للنصوص الفرعية في المصادقة
class AuthSubtitle extends StatelessWidget {
  final String text;
  final Color? color;
  final double? mobileSize;
  final double? tabletSize;
  final double? desktopSize;

  const AuthSubtitle(
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
      mobileSize: mobileSize ?? 14,
      tabletSize: tabletSize ?? 16,
      desktopSize: desktopSize ?? 18,
      style: TextStyle(
        color: color ?? Colors.grey[600],
      ),
      textAlign: TextAlign.center,
    );
  }
} 