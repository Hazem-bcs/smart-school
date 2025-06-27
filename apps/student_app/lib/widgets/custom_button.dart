import 'package:flutter/material.dart';
class CustomButton extends StatelessWidget {
    CustomButton({
    required this.content,
    required this.onPressed,
    this.borderColor,
    this.buttonColor=Colors.blue,
    required this.width,
    this.shapeBorder,
    this.shadowColor,
    this.elevation,
  });

  final Widget content;
  final Color buttonColor;
  final Color? borderColor;
  final void Function()? onPressed;
  final double width;
  final OutlinedBorder? shapeBorder;
  final Color? shadowColor;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:width ,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          side: BorderSide(
            color: borderColor ?? buttonColor,
            width: 0,
          ),
          backgroundColor: buttonColor,
          shape:shapeBorder,
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 15,
          ),
            shadowColor: shadowColor,
          elevation: elevation,
        ),
        onPressed: onPressed,
        child: content,
      ),
    );
  }
}
