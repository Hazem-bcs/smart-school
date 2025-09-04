import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';
import '../../../../widgets/responsive/responsive_helper.dart';
import '../../../../widgets/modern_design/modern_effects.dart';

class SettingsHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onBackPressed;

  const SettingsHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final defaultIconColor = iconColor ?? (isDark ? AppColors.darkAccentBlue : AppColors.primary);

    return Container(
      margin: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 24, tablet: 28, desktop: 32)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark 
              ? [
                  AppColors.darkGradientStart,
                  AppColors.darkGradientEnd,
                ]
              : [
                  AppColors.primary,
                  AppColors.secondary,
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.darkGradientStart : AppColors.primary).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          if (onBackPressed != null) ...[
            GestureDetector(
              onTap: onBackPressed,
              child: Container(
                padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 14, desktop: 16)),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: AppColors.white,
                  size: ResponsiveHelper.getIconSize(context, mobile: 20, tablet: 22, desktop: 24),
                ),
              ),
            ),
            SizedBox(width: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24)),
          ],
          Container(
            width: ResponsiveHelper.getIconSize(context, mobile: 60, tablet: 70, desktop: 80),
            height: ResponsiveHelper.getIconSize(context, mobile: 60, tablet: 70, desktop: 80),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: AppColors.white,
              size: ResponsiveHelper.getIconSize(context, mobile: 30, tablet: 35, desktop: 40),
            ),
          ),
          SizedBox(width: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getFontSize(context, mobile: 20, tablet: 22, desktop: 24),
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 4, tablet: 6, desktop: 8)),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                    color: AppColors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

