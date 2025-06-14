

import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  const ErrorText({super.key, required this.message});

  final String message;
  @override
  Widget build(BuildContext context) {
    return Text(message , textAlign: TextAlign.center,style: const TextStyle(
      color: Colors.red,
      fontSize: 16,
    ),);
  }
}
