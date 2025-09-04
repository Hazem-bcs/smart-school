import 'package:flutter/material.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_spacing.dart';
import 'package:core/theme/constants/app_text_styles.dart';
import 'package:core/theme/constants/app_strings.dart';

/// Widget لعرض حالة عدم وجود موارد
class ResourceEmptyStateWidget extends StatelessWidget {
  final VoidCallback? onRefresh;

  const ResourceEmptyStateWidget({
    super.key,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh?.call();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Padding(
            padding: AppSpacing.xlPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder_open_outlined,
                  size: 80,
                  color: isDark ? AppColors.darkSecondaryText : AppColors.gray400,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  AppStrings.noResources,
                  style: AppTextStyles.h3.copyWith(
                    color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  AppStrings.resourcesComingSoon,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDark ? AppColors.darkSecondaryText : AppColors.gray500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                if (onRefresh != null)
                  ElevatedButton.icon(
                    onPressed: onRefresh,
                    icon: const Icon(Icons.refresh),
                    label: Text(AppStrings.refresh),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppColors.darkAccentPurple : AppColors.secondary,
                      foregroundColor: isDark ? AppColors.black : AppColors.white,
                      padding: AppSpacing.buttonPadding,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppSpacing.baseBorderRadius,
                      ),
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
