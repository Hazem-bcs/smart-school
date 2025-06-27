import 'package:flutter/material.dart';

class AppAvatarWidget extends StatelessWidget {
  final String imageUrl;
  final bool isBordered;
  final Color borderColor;
  final double radius;
  final double borderThickness;

  const AppAvatarWidget({
    Key? key,
    required this.imageUrl,
    this.isBordered = false,
    this.borderColor = Colors.blue,
    this.radius = 20,
    this.borderThickness = 2.0,
  }) : assert(radius >= borderThickness),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: borderColor,
          child: CircleAvatar(
            radius: isBordered ? radius - borderThickness : radius,
            backgroundColor: Colors.grey,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Image.asset(
                imageUrl,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
