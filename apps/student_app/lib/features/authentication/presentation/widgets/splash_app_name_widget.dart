import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_text_styles.dart';
import 'package:core/theme/constants/app_spacing.dart';
import '../../../../generated/locale_keys.g.dart';

/// Widget for splash page app name with animations
class SplashAppNameWidget extends StatelessWidget {
  final Animation<double> slideAnimation;
  final Animation<double> opacityAnimation;

  const SplashAppNameWidget({
    super.key,
    required this.slideAnimation,
    required this.opacityAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, slideAnimation.value),
          child: Opacity(
            opacity: opacityAnimation.value,
            child: Column(
              children: [
                Text(
                  LocaleKeys.stellar.tr(),
                  style: AppTextStyles.h1.copyWith(
                    color: AppColors.white,
                    fontSize: 40,
                    fontWeight: AppTextStyles.bold,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        color: AppColors.black.withAlpha((0.15 * 255).toInt()),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Smart School',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.white.withAlpha((0.8 * 255).toInt()),
                    fontSize: 18,
                    fontWeight: AppTextStyles.medium,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
