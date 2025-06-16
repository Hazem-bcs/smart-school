import 'package:flutter/material.dart';

class AppIconWidget extends StatelessWidget {
  final IconData? icon;
  final Color? color;
  final double? size;

  const AppIconWidget({
    super.key,
    this.icon,
    this.color = Colors.grey,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: color,
      size: size,
    );
  }
}
