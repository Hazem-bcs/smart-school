import 'package:flutter/material.dart';
import '../../../../../core/responsive/responsive_helper.dart';

/// Widget متجاوب لبطاقات المصادقة
class AuthCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double? elevation;

  const AuthCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation ?? ResponsiveHelper.getCardElevation(context),
      color: backgroundColor ?? Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context)),
      ),
      child: Padding(
        padding: padding ?? ResponsiveHelper.getScreenPadding(context),
        child: child,
      ),
    );
  }
} 