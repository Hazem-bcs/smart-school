import 'package:flutter/material.dart';
import '../../../../../core/responsive/responsive_helper.dart';
import '../../../../../core/responsive/responsive_widgets.dart';
import 'package:core/theme/constants/app_colors.dart';

class AssignmentListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final VoidCallback? onTap;
  final int index;

  const AssignmentListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return MouseRegion(
      onEnter: (_) => {}, // يمكن إضافة منطق hover خارجي إذا لزم
      onExit: (_) => {},
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context),
            vertical: ResponsiveHelper.getSpacing(context, mobile: 4, tablet: 6, desktop: 8),
          ),
          padding: ResponsiveHelper.getScreenPadding(context),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBackground : theme.cardColor,
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getBorderRadius(context),
            ),
            border: Border.all(
              color: isDark ? AppColors.darkCardBackground : theme.dividerColor.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // أيقونة الحالة
              Container(
                width: ResponsiveHelper.getIconSize(context, mobile: 40, tablet: 48, desktop: 56),
                height: ResponsiveHelper.getIconSize(context, mobile: 40, tablet: 48, desktop: 56),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getBorderRadius(context),
                  ),
                ),
                child: Icon(
                  isCompleted ? Icons.check_circle : Icons.pending,
                  color: isCompleted ? Colors.green : Colors.orange,
                  size: ResponsiveHelper.getIconSize(context, mobile: 24, tablet: 28, desktop: 32),
                ),
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context)),
              // المحتوى
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveText(
                      title,
                      mobileSize: 16,
                      tabletSize: 18,
                      desktopSize: 20,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.titleMedium?.color,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 4, tablet: 6, desktop: 8)),
                    ResponsiveText(
                      subtitle,
                      mobileSize: 14,
                      tabletSize: 16,
                      desktopSize: 18,
                      style: TextStyle(
                        color: isDark ? theme.textTheme.bodyMedium?.color : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // سهم التنقل
              ResponsiveIcon(
                Icons.arrow_forward_ios,
                mobileSize: 16,
                tabletSize: 18,
                desktopSize: 20,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 