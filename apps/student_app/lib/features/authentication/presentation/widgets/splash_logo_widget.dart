import 'package:flutter/material.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_spacing.dart';

/// Widget for splash page logo with animations
class SplashLogoWidget extends StatelessWidget {
  final Animation<double> scaleAnimation;
  final Animation<double> opacityAnimation;

  const SplashLogoWidget({
    super.key,
    required this.scaleAnimation,
    required this.opacityAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: scaleAnimation.value,
          child: Opacity(
            opacity: opacityAnimation.value,
            child: Container(
              padding: AppSpacing.xlPadding,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark 
                  ? AppColors.darkCardBackground.withAlpha((0.08 * 255).toInt())
                  : AppColors.white.withAlpha((0.08 * 255).toInt()),
                boxShadow: [
                  BoxShadow(
                    color: isDark 
                      ? AppColors.black.withAlpha((0.1 * 255).toInt())
                      : AppColors.black.withAlpha((0.05 * 255).toInt()),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/graduation-hat.png',
                color: AppColors.white,
                height: 100,
              ),
            ),
          ),
        );
      },
    );
  }
}
