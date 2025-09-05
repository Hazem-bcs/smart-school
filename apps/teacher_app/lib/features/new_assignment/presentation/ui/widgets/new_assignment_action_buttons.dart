import 'package:flutter/material.dart';
import '../../../../../core/responsive/responsive_helper.dart';
import '../../../../../core/responsive/responsive_widgets.dart';
import 'package:core/theme/constants/app_colors.dart';

class NewAssignmentActionButtons extends StatelessWidget {
  final bool isDark;
  final bool isLoading;
  final VoidCallback onSaveAsDraft;
  final VoidCallback onPublish;
  const NewAssignmentActionButtons({Key? key, required this.isDark, required this.isLoading, required this.onSaveAsDraft, required this.onPublish}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24),
      ),
      child: ResponsiveLayout(
        mobile: Column(
          children: [
            _buildActionButton(text: 'حفظ كمسودة', onPressed: isLoading ? null : onSaveAsDraft, isDark: isDark, isPrimary: false, isLoading: isLoading, context: context),
            SizedBox(height: ResponsiveHelper.getSpacing(context)),
            _buildActionButton(text: 'نشر', onPressed: isLoading ? null : onPublish, isDark: isDark, isPrimary: true, isLoading: isLoading, context: context),
          ],
        ),
        tablet: Row(
          children: [
            Expanded(child: _buildActionButton(text: 'حفظ كمسودة', onPressed: isLoading ? null : onSaveAsDraft, isDark: isDark, isPrimary: false, isLoading: isLoading, context: context)),
            SizedBox(width: ResponsiveHelper.getSpacing(context)),
            Expanded(child: _buildActionButton(text: 'نشر', onPressed: isLoading ? null : onPublish, isDark: isDark, isPrimary: true, isLoading: isLoading, context: context)),
          ],
        ),
        desktop: Row(
          children: [
            Expanded(child: _buildActionButton(text: 'حفظ كمسودة', onPressed: isLoading ? null : onSaveAsDraft, isDark: isDark, isPrimary: false, isLoading: isLoading, context: context)),
            SizedBox(width: ResponsiveHelper.getSpacing(context)),
            Expanded(child: _buildActionButton(text: 'نشر', onPressed: isLoading ? null : onPublish, isDark: isDark, isPrimary: true, isLoading: isLoading, context: context)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback? onPressed,
    required bool isDark,
    required bool isPrimary,
    required bool isLoading,
    required BuildContext context,
  }) {
    final color = isPrimary ? (isDark ? Colors.white : AppColors.primary) : (isDark ? Colors.white : AppColors.primary);
    final background = isPrimary ? (isDark ? Colors.transparent : AppColors.primary) : (isDark ? Colors.transparent : null);
    final child = isLoading
        ? SizedBox(
            width: ResponsiveHelper.getIconSize(context, mobile: 24, tablet: 28, desktop: 32),
            height: ResponsiveHelper.getIconSize(context, mobile: 24, tablet: 28, desktop: 32),
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          )
        : Text(
            text,
            style: TextStyle(
              fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 18),
              color: color,
              fontWeight: FontWeight.w700,
            ),
          );
    if (isPrimary) {
      return Container(
        height: ResponsiveHelper.getButtonHeight(context) + 8,
        decoration: isDark
            ? BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.darkGradientStart, AppColors.darkGradientEnd],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkGradientStart.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              )
            : null,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: background,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getSpacing(context, mobile: 28, tablet: 32, desktop: 36),
              vertical: ResponsiveHelper.getSpacing(context, mobile: 18, tablet: 20, desktop: 22),
            ),
          ),
          child: child,
        ),
      );
    } else {
      return Container(
        height: ResponsiveHelper.getButtonHeight(context) + 8,
        decoration: isDark
            ? BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.darkCardBackground, AppColors.darkElevatedSurface],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.darkAccentBlue.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkGradientStart.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              )
            : null,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: background,
            side: BorderSide(
              color: isDark ? Colors.transparent : AppColors.primary,
              width: isDark ? 0 : 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getSpacing(context, mobile: 28, tablet: 32, desktop: 36),
              vertical: ResponsiveHelper.getSpacing(context, mobile: 18, tablet: 20, desktop: 22),
            ),
          ),
          child: child,
        ),
      );
    }
  }
} 