import 'package:flutter/material.dart';
import 'package:core/theme/constants/app_strings.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_spacing.dart';

/// Widget for displaying empty state in notification page
class NotificationEmptyWidget extends StatelessWidget {
  final VoidCallback onRefresh;

  const NotificationEmptyWidget({
    Key? key,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
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
                    Icons.notifications_off,
                    size: 80,
                    color: isDark ? AppColors.darkSecondaryText : AppColors.gray400,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    AppStrings.noNotifications,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
                    ),
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
