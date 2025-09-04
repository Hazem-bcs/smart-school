import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';
import '../../../../widgets/responsive/responsive_helper.dart';
import '../../../../widgets/modern_design/modern_effects.dart';

class LogoutDialog extends StatelessWidget {
  final ThemeData theme;
  final bool isDark;
  final VoidCallback onConfirm;

  const LogoutDialog({
    super.key,
    required this.theme,
    required this.isDark,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ModernEffects.glassmorphism(
        isDark: isDark,
        opacity: 0.95,
        blur: 20.0,
        borderOpacity: 0.3,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 24, tablet: 28, desktop: 32)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogIcon(context),
              SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28)),
              _buildDialogTitle(context),
              SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20)),
              _buildDialogContent(context),
              SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 28, tablet: 32, desktop: 36)),
              _buildDialogActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogIcon(BuildContext context) {
    final iconColor = isDark ? AppColors.darkDestructive : AppColors.error;
    
    return Container(
      width: ResponsiveHelper.getIconSize(context, mobile: 70, tablet: 80, desktop: 90),
      height: ResponsiveHelper.getIconSize(context, mobile: 70, tablet: 80, desktop: 90),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            iconColor.withOpacity(0.2),
            iconColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: iconColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Icon(
        Icons.logout_rounded,
        color: iconColor,
        size: ResponsiveHelper.getIconSize(context, mobile: 35, tablet: 40, desktop: 45),
      ),
    );
  }

  Widget _buildDialogTitle(BuildContext context) {
    return Text(
      'تسجيل الخروج',
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: ResponsiveHelper.getFontSize(context, mobile: 22, tablet: 24, desktop: 26),
        color: isDark ? AppColors.darkPrimaryText : AppColors.gray800,
      ),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Text(
      'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
      textAlign: TextAlign.center,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
        color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
        height: 1.5,
      ),
    );
  }

  Widget _buildDialogActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildCancelButton(context),
        ),
        SizedBox(width: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20)),
        Expanded(
          child: _buildLogoutButton(context),
        ),
      ],
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return Container(
      height: ResponsiveHelper.getButtonHeight(context),
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? AppColors.darkElevatedSurface : AppColors.gray100,
          foregroundColor: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          'إلغاء',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final buttonColor = isDark ? AppColors.darkDestructive : AppColors.error;
    
    return Container(
      height: ResponsiveHelper.getButtonHeight(context),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            buttonColor,
            buttonColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: buttonColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onConfirm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          'تسجيل الخروج',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

