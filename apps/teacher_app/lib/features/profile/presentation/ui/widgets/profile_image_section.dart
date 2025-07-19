import 'package:flutter/material.dart';
import 'dart:io';
import 'package:core/theme/constants/app_colors.dart';
import '../../../../../core/responsive/responsive_helper.dart';

class ProfileImageSection extends StatelessWidget {
  final bool isDark;
  final File? selectedImage;
  final VoidCallback onImageTap;

  const ProfileImageSection({
    super.key,
    required this.isDark,
    required this.selectedImage,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28)),
      child: Column(
        children: [
          GestureDetector(
            onTap: onImageTap,
            child: Container(
              width: ResponsiveHelper.getIconSize(context, mobile: 100, tablet: 120, desktop: 140),
              height: ResponsiveHelper.getIconSize(context, mobile: 100, tablet: 120, desktop: 140),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark 
                      ? [AppColors.darkGradientStart, AppColors.darkGradientEnd]
                      : [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(ResponsiveHelper.getIconSize(context, mobile: 50, tablet: 60, desktop: 70)),
                boxShadow: [
                  BoxShadow(
                    color: (isDark ? AppColors.darkGradientStart : AppColors.primary).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.getIconSize(context, mobile: 50, tablet: 60, desktop: 70)),
                      child: Image.file(
                        selectedImage!,
                        width: ResponsiveHelper.getIconSize(context, mobile: 100, tablet: 120, desktop: 140),
                        height: ResponsiveHelper.getIconSize(context, mobile: 100, tablet: 120, desktop: 140),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      Icons.person,
                      color: Colors.white,
                      size: ResponsiveHelper.getIconSize(context, mobile: 50, tablet: 60, desktop: 70),
                    ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24)),
          GestureDetector(
            onTap: onImageTap,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28),
                vertical: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark 
                      ? [AppColors.darkCardBackground, AppColors.darkElevatedSurface]
                      : [AppColors.gray50, AppColors.gray100],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkAccentBlue.withOpacity(0.3) : AppColors.primary.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.camera_alt,
                    color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
                    size: ResponsiveHelper.getIconSize(context, mobile: 20, tablet: 24, desktop: 28),
                  ),
                  SizedBox(width: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16)),
                  Text(
                    'Change Photo',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 