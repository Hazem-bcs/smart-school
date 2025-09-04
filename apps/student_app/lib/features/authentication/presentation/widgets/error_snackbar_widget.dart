import 'package:flutter/material.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_text_styles.dart';
import 'package:core/theme/constants/app_spacing.dart';

/// Widget for displaying error messages in snackbar format
class ErrorSnackBarWidget {
  static void show({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: AppColors.white,
              size: 20,
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.mdBorderRadius,
        ),
        margin: AppSpacing.baseMargin,
        duration: duration,
        action: SnackBarAction(
          label: 'إغلاق',
          textColor: AppColors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
