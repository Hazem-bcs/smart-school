import 'package:flutter/material.dart';
import 'package:smart_school/features/post/presentation/widgets/app_button_like_widget.dart';

import '../../../../widgets/app_avatar_widget.dart';
import '../../../../widgets/app_circle_button_widget.dart';
import '../../../../widgets/app_icon_widget.dart';
import '../../../../widgets/app_image_widget.dart';
import '../../../../widgets/app_text_widget.dart';



class PostWidget extends StatefulWidget {
  const PostWidget({super.key});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {

  @override
  Widget build(BuildContext context) {

    return Card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AppAvatarWidget(
                imageUrl: 'assets/images/graduation-hat.png',
                // imageUrl: imageUrl,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppTextWidget(
                      text: "userName",
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    Row(
                      children: [
                        AppTextWidget(
                          // text: "$timeAgo • ",
                          text: "10.0 • ",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        AppIconWidget(icon: Icons.public, size: 12),
                      ],
                    ),
                  ],
                ),
              ),
              AppCircleButtonWidget(
                iconData: Icons.more_horiz,
                onPressed: () {},
                iconSize: 30,
              ),
            ],
          ),
          AppTextWidget(text: "caption"),
          AppImageWidget(path: 'assets/images/graduation-hat.png', height: 200),
         Row(
           children: [
             Expanded(child: AppButtonLikeWidget(icon: Icons.thumb_up)),
             // SizedBox(width: 5,),
             // Expanded(child: AppButtonLikeWidget(icon: Icons.thumb_down)),
           ],
         ),
        ],
      ),
    );
  }
}
