
import 'package:core/theme/constants/colors.dart';
import 'package:flutter/material.dart';


class AppButtonLikeWidget extends StatefulWidget {
  final IconData icon;

  const AppButtonLikeWidget({super.key, required this.icon});

  @override
  State<AppButtonLikeWidget> createState() => _AppButtonLikeWidgetState();
}

class _AppButtonLikeWidgetState extends State<AppButtonLikeWidget> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      height: 30,
      decoration: BoxDecoration(color: isLiked ? Colors.white : primaryColor),
      child: IconButton(
        onPressed: () {
          setState(() {
            isLiked = !isLiked;
          });
        },
        icon: Icon(
          Icons.thumb_up,
          size: 20,
          color: isLiked ? primaryColor : Colors.white,
        ),
      ),
    );
  }
}
