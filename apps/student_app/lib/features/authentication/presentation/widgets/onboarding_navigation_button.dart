import 'package:flutter/material.dart';
import 'package:core/theme/constants/app_colors.dart';


/// Widget for onboarding navigation button
class OnboardingNavigationButton extends StatelessWidget {
  final bool isLastPage;
  final VoidCallback onPressed;

  const OnboardingNavigationButton({
    super.key,
    required this.isLastPage,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Positioned(
      bottom: 40,
      child: InkWell(
        onTap: onPressed,
        child: CircleAvatar(
          backgroundColor: isDark ? AppColors.darkAccentBlue : AppColors.primary,
          radius: 30,
          child: Center(
            child: Icon(
              isLastPage ? Icons.check : Icons.arrow_forward_ios,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
