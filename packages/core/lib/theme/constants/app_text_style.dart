
import 'package:flutter/material.dart';

class AppTextStyle{
//appBar
  static TextStyle appBarTitle(BuildContext context) {
      double screenWidth = MediaQuery.of(context).size.width;
      double fontSize;
      if (screenWidth < 360) {
        fontSize = 20;
      } else if (screenWidth < 480) {
        fontSize = 24;
      } else {
        fontSize = 28;
      }

      return Theme.of(context).textTheme.titleLarge!.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
      letterSpacing: 1.2,
      shadows: [
        Shadow(
          color: Colors.black26,
          offset: Offset(1, 1),
          blurRadius: 2,
        )
      ],
    );
  }



}