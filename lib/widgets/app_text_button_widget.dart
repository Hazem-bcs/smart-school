import 'package:flutter/material.dart';

class AppTextButtonWidget extends StatelessWidget {
  final IconData iconButton;
  final double? iconSize;
  final String label;

  AppTextButtonWidget({
    super.key,
    required this.iconButton,
    required this.label,
    this.iconSize=16,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {},
      icon: Icon(iconButton,size: iconSize,),
      label: Text(label),
    );
  }
}
