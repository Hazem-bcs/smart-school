import 'package:flutter/material.dart';
import 'package:core/theme/constants/app_strings.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_spacing.dart';

/// Widget for displaying error state in notification page
class NotificationErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const NotificationErrorWidget({
    Key? key,
    required this.errorMessage,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return RefreshIndicator(
      onRefresh: () async => onRetry(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
          child: Center(
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 80,
                    color: isDark ? AppColors.darkDestructive : AppColors.error,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    '${AppStrings.errorLoadingNotifications}\n$errorMessage',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: isDark ? AppColors.darkDestructive : AppColors.error,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  ElevatedButton(
                    onPressed: onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppColors.darkAccentBlue : AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: AppSpacing.buttonPadding,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppSpacing.baseBorderRadius,
                      ),
                    ),
                    child: Text(AppStrings.retry),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
