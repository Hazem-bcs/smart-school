import 'package:flutter/material.dart';

class AppRoundButtonWidget extends StatelessWidget {
  final String title;
  final Function() onPress;
  final Color? backGroundColor;
  final Color? textColor;
  final double height;
  final double width;

  const AppRoundButtonWidget({
    super.key,
    required this.title,
    required this.onPress,
    this.backGroundColor,
    this.height = 40,
    this.width = 100,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: backGroundColor,
        ),
        child: Center(child: Text(title,style: TextStyle(color: textColor),)),
      ),
    );
  }
}
