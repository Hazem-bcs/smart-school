import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';

import '../../../../widgets/responsive/responsive_helper.dart';

class ProfileCard extends StatelessWidget {
  final ThemeData theme;
  final bool isDark;
  final Animation<double> scaleAnimation;
  final VoidCallback onEditProfile;
  final String name;
  final String email;

  const ProfileCard({
    Key? key,
    required this.theme,
    required this.isDark,
    required this.scaleAnimation,
    required this.onEditProfile,
    required this.name,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Container(
        margin: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
        padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [AppColors.darkGradientStart, AppColors.darkGradientEnd]
                : [AppColors.primary, AppColors.secondary],
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
            Container(
              width: ResponsiveHelper.getIconSize(context, mobile: 60, tablet: 70, desktop: 80),
              height: ResponsiveHelper.getIconSize(context, mobile: 60, tablet: 70, desktop: 80),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.person,
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
                    name.isNotEmpty ? name : 'اسم المستخدم',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getFontSize(context, mobile: 18, tablet: 20, desktop: 22),
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 4, tablet: 6, desktop: 8)),
                  Text(
                    email.isNotEmpty ? email : 'البريد الإلكتروني',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                      color: AppColors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onEditProfile,
              child: Container(
                padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 10, desktop: 12)),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.edit,
                  color: AppColors.white,
                  size: ResponsiveHelper.getIconSize(context, mobile: 18, tablet: 20, desktop: 22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}