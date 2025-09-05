import 'package:flutter/material.dart';
import 'package:core/theme/constants/app_colors.dart';
import '../../../../../core/responsive/responsive_helper.dart';
import '../../../../../core/responsive/responsive_widgets.dart';

class ActionButtons extends StatelessWidget {
  final bool isDark;
  final bool isLoading;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const ActionButtons({
    super.key,
    required this.isDark,
    required this.isLoading,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24),
      ),
      child: ResponsiveLayout(
        mobile: Column(
          children: [
            _buildSaveButton(context),
            SizedBox(height: ResponsiveHelper.getSpacing(context)),
            _buildCancelButton(context),
          ],
        ),
        tablet: Row(
          children: [
            Expanded(child: _buildCancelButton(context)),
            SizedBox(width: ResponsiveHelper.getSpacing(context)),
            Expanded(child: _buildSaveButton(context)),
          ],
        ),
        desktop: Row(
          children: [
            Expanded(child: _buildCancelButton(context)),
            SizedBox(width: ResponsiveHelper.getSpacing(context)),
            Expanded(child: _buildSaveButton(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Container(
      height: ResponsiveHelper.getButtonHeight(context) + 8,
      decoration: isDark ? BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkGradientStart,
            AppColors.darkGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGradientStart.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ) : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? Colors.transparent : AppColors.primary,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, mobile: 28, tablet: 32, desktop: 36),
            vertical: ResponsiveHelper.getSpacing(context, mobile: 18, tablet: 20, desktop: 22),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: ResponsiveHelper.getIconSize(context, mobile: 24, tablet: 28, desktop: 32),
                height: ResponsiveHelper.getIconSize(context, mobile: 24, tablet: 28, desktop: 32),
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? AppColors.darkAccentBlue : AppColors.primary,
                  ),
                ),
              )
            : Text(
                'حفظ التغييرات',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                  color: isDark ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return Container(
      height: ResponsiveHelper.getButtonHeight(context) + 8,
      decoration: isDark ? BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkCardBackground,
            AppColors.darkElevatedSurface,
          ],
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
      ) : null,
      child: OutlinedButton(
        onPressed: isLoading ? null : onCancel,
        style: OutlinedButton.styleFrom(
          backgroundColor: isDark ? Colors.transparent : null,
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
        child: Text(
          'إلغاء',
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 18),
            color: isDark ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
} 