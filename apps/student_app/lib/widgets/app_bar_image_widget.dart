import 'package:core/theme/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../generated/locale_keys.g.dart';

class AppBarImageWidget extends StatelessWidget {
  final double? height;
  final bool? isImage;
  final String? title;
  final String? imageName;

  const AppBarImageWidget({
    super.key,
    this.height = 20,
    this.isImage,
    this.title,
    this.imageName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isImage == true)
            Image.asset(
              imageName!,
              // 'assets/images/graduation-hat.png',
              color: secondaryColor,
              height: 150,
            ),

          const SizedBox(height: 10),
          Text(
            title ?? LocaleKeys.stellar.tr(),
            style: const TextStyle(
              color: secondaryColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
