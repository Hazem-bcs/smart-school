import 'package:flutter/material.dart';

class AppTextWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;

  AppTextWidget({
    super.key,
    required this.text,
    this.style,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
    );
  }
}
