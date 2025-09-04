import 'package:flutter/material.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_text_styles.dart';
import 'package:core/theme/constants/app_spacing.dart';

class ProfileErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ProfileErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error Icon
            Container(
              padding: AppSpacing.lgPadding,
              decoration: BoxDecoration(
                color: isDark 
                  ? AppColors.darkDestructive.withOpacity(0.1)
                  : AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: isDark ? AppColors.darkDestructive : AppColors.error,
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Error Title
            Text(
              'حدث خطأ في تحميل البيانات',
              style: AppTextStyles.h4.copyWith(
                color: isDark ? AppColors.darkPrimaryText : AppColors.gray900,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Error Message
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Retry Button
            _buildRetryButton(theme, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildRetryButton(ThemeData theme, bool isDark) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
            ? [AppColors.darkAccentBlue, AppColors.darkAccentPurple]
            : [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: AppSpacing.baseBorderRadius,
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.darkAccentBlue : AppColors.primary).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onRetry,
        icon: Icon(
          Icons.refresh,
          color: AppColors.white,
          size: 20,
        ),
        label: Text(
          'إعادة المحاولة',
          style: AppTextStyles.buttonPrimary.copyWith(
            color: AppColors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.baseBorderRadius,
          ),
        ),
      ),
    );
  }
}
