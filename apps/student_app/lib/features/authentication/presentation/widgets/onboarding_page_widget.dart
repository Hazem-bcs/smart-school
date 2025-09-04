import 'package:flutter/material.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_text_styles.dart';
import 'package:core/theme/constants/app_spacing.dart';

/// Widget for onboarding page content
class OnboardingPageWidget extends StatelessWidget {
  final String title;
  final String imagePath;
  final Color backgroundColor;
  final double imageHeight;

  const OnboardingPageWidget({
    super.key,
    required this.title,
    required this.imagePath,
    required this.backgroundColor,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      color: backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: AppSpacing.screenPaddingCompact,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.h1.copyWith(
                  fontSize: 30,
                  fontWeight: AppTextStyles.regular,
                  color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.xl3),
            Image.asset(
              imagePath,
              height: imageHeight,
            ),
          ],
        ),
      ),
    );
  }
}
