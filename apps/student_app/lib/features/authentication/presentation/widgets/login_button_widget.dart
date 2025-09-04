import 'package:flutter/material.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_text_styles.dart';
import 'package:core/theme/constants/app_spacing.dart';
import 'package:core/widgets/index.dart';

/// Widget for login button with theme support and loading state
class LoginButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const LoginButtonWidget({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: AppSpacing.baseBorderRadius,
        gradient: LinearGradient(
          colors: isDark
            ? [AppColors.darkAccentBlue, AppColors.darkAccentPurple]
            : [AppColors.primary, AppColors.secondary],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
              ? AppColors.darkAccentBlue.withOpacity(0.3)
              : AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppSpacing.baseBorderRadius,
          onTap: isLoading ? null : onPressed,
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: SmartSchoolLoading(
                      type: LoadingType.pulse,
                      size: 24,
                      showMessage: false,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.login,
                        color: AppColors.white,
                        size: 20,
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Text(
                        'تسجيل الدخول',
                        style: AppTextStyles.buttonPrimary.copyWith(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: AppTextStyles.semiBold,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
