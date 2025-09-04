import 'package:flutter/material.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_text_styles.dart';
import 'package:core/theme/constants/app_spacing.dart';

/// Widget for login page header with theme support
class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Column(
      children: [
        // Logo/Icon
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: isDark 
              ? AppColors.darkCardBackground.withOpacity(0.2)
              : AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: isDark
                  ? AppColors.darkAccentBlue.withOpacity(0.3)
                  : AppColors.primary.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.school,
            size: 60,
            color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
          ),
        ),
        
        SizedBox(height: AppSpacing.xl),
        
        // Title
        Text(
          'مرحباً بك في المدرسة الذكية',
          style: AppTextStyles.h1.copyWith(
            color: isDark ? AppColors.darkPrimaryText : AppColors.primary,
            fontSize: 28,
            fontWeight: AppTextStyles.bold,
          ),
          textAlign: TextAlign.center,
        ),
        
        SizedBox(height: AppSpacing.sm),
        
        // Subtitle
        Text(
          'سجل دخولك للوصول إلى حسابك',
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
