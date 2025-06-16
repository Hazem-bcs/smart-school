import 'package:flutter/material.dart';

class AppCircleButtonWidget extends StatelessWidget {
  final IconData iconData;
  final double iconSize;
  final Color iconColor;
  final void Function() onPressed;
  final double? backgroundSize;
  final Color? backgroundColor;
  final double margin;

  AppCircleButtonWidget({
    super.key,
    required this.iconData,
    this.iconSize = 30,
    this.iconColor = Colors.black,
    required this.onPressed,
    this.backgroundSize,
    this.margin = 6.0,
    this.backgroundColor ,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: backgroundSize,
      height: backgroundSize,
      margin: EdgeInsetsDirectional.all(margin),
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: IconButton(
        onPressed: onPressed,
        icon: Center(
          child: Icon(
            iconData,
            size: iconSize,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
