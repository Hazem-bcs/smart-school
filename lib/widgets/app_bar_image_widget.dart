import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../generated/locale_keys.g.dart';
import '../theme/colors.dart';

class AppBarImageWidget extends StatelessWidget {
  const AppBarImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
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
          Image.asset(
            'assets/images/graduation-hat.png',
            color: secondaryColor,
            height: 150,
          ),
          const SizedBox(height: 10),
          Text(
            LocaleKeys.stellar.tr(),
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
