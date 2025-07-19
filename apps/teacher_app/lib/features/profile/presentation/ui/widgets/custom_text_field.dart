import 'package:flutter/material.dart';
import 'package:core/theme/constants/app_colors.dart';
import '../../../../../core/responsive/responsive_helper.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final String? Function(String?)? validator;
  final bool isDark;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.isDark,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28)),
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
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGradientStart.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ) : null,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
            color: isDark ? Colors.white.withOpacity(0.8) : Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
          filled: true,
          fillColor: isDark ? Colors.transparent : Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkAccentBlue.withOpacity(0.3) : Colors.grey[300]!,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkAccentBlue.withOpacity(0.3) : Colors.grey[300]!,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
              width: 2.5,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28),
            vertical: ResponsiveHelper.getSpacing(context, mobile: 18, tablet: 22, desktop: 26),
          ),
        ),
        validator: validator,
      ),
    );
  }
} 