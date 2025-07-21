import 'package:flutter/material.dart';

class DecoratedSectionContainer extends StatelessWidget {
  final Widget child;
  final bool isDark;
  final BoxDecoration? lightDecoration;
  final BoxDecoration? darkDecoration;
  final EdgeInsetsGeometry? margin;
  const DecoratedSectionContainer({
    super.key,
    required this.child,
    required this.isDark,
    this.lightDecoration,
    this.darkDecoration,
    this.margin,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: isDark ? darkDecoration : lightDecoration,
      child: child,
    );
  }
} 