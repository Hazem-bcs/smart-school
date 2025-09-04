import 'package:flutter/material.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_text_styles.dart';
import 'package:core/theme/constants/app_spacing.dart';

/// Widget for test connection button with theme support
class TestConnectionButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const TestConnectionButtonWidget({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: AppSpacing.mdBorderRadius,
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.gray300,
        ),
        color: isDark ? AppColors.darkCardBackground : AppColors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppSpacing.mdBorderRadius,
          onTap: onPressed,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi,
                  color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
                  size: 18,
                ),
                SizedBox(width: AppSpacing.sm),
                Text(
                  'اختبار الاتصال',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
                    fontSize: 14,
                    fontWeight: AppTextStyles.medium,
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
