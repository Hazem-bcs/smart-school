import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';


class VerificationNumberFields extends StatefulWidget {
  const VerificationNumberFields({
    Key? key,
    required this.onCompleted,
    this.validator,
    required this.onChanged,
  }) : super(key: key);

  final ValueChanged<String> onCompleted;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;

  @override
  State<VerificationNumberFields> createState() => _VerificationNumberFieldsState();
}

class _VerificationNumberFieldsState extends State<VerificationNumberFields> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final defaultPinTheme = PinTheme(
      width: min(60,size.width / 6) ,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey.shade400,
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      borderRadius: BorderRadius.circular(15),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(),
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: submittedPinTheme,
        validator: widget.validator,
        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
        showCursor: true,
        pinAnimationType: PinAnimationType.slide,
        onCompleted: widget.onCompleted,
        onChanged: widget.onChanged,
        length: 6,
        inputFormatters: [
        ],
      ),
    );
  }
}
