import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_text_styles.dart';

/// Widget لحالة عدم وجود مستحقات
class DuesEmptyWidget extends StatelessWidget {
  final RefreshCallback onRefresh;

  const DuesEmptyWidget({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: theme.colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: 300,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 80,
                  color: isDark ? AppColors.darkSecondaryText : AppColors.gray400,
                ),
                const SizedBox(height: 24),
                Text(
                  'لا توجد مستحقات حالياً',
                  style: AppTextStyles.h3.copyWith(
                    color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'جميع المستحقات مدفوعة أو لا توجد مستحقات جديدة',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDark ? AppColors.darkSecondaryText : AppColors.gray500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('تحديث'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
