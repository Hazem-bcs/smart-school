import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:core/theme/constants/app_colors.dart';

import '../../../../widgets/responsive/responsive_helper.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String? placeholder;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final bool obscureText;
  final VoidCallback? onTap;
  final bool readOnly;

  const CustomTextFormField({
    super.key,
    required this.label,
    this.placeholder,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.obscureText = false,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Focus(
      child: Builder(
        builder: (context) {
          final hasFocus = Focus.of(context).hasFocus;
          return Container(
            margin: EdgeInsets.only(
              bottom: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28),
            ),
            decoration: isDark
                ? BoxDecoration(
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
                  )
                : null,
            child: TextFormField(
              controller: controller,
              validator: validator,
              keyboardType: keyboardType,
              maxLines: maxLines,
              maxLength: maxLength,
              inputFormatters: inputFormatters,
              enabled: enabled,
              obscureText: obscureText,
              onTap: onTap,
              readOnly: readOnly,
              style: TextStyle(
                fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                color: isDark ? Colors.white : theme.textTheme.bodyLarge?.color,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: label,
                hintText: placeholder,
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                filled: true,
                fillColor: isDark
                    ? Colors.transparent
                    : (hasFocus
                        ? Theme.of(context).primaryColor.withOpacity(0.05)
                        : Colors.grey[50]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.darkAccentBlue.withOpacity(0.3)
                        : Colors.grey[300]!,
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.darkAccentBlue.withOpacity(0.3)
                        : Colors.grey[300]!,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.darkAccentBlue
                        : Theme.of(context).primaryColor,
                    width: 2.5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.darkDestructive
                        : Colors.red[400]!,
                    width: 1.5,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.darkDestructive
                        : Colors.red[400]!,
                    width: 2.5,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28),
                  vertical: ResponsiveHelper.getSpacing(context, mobile: 18, tablet: 22, desktop: 26),
                ),
                labelStyle: TextStyle(
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                  color: isDark
                      ? (hasFocus ? Colors.white : Colors.white.withOpacity(0.8))
                      : (hasFocus ? Theme.of(context).primaryColor : Colors.grey[600]),
                  fontWeight: FontWeight.w600,
                ),
                hintStyle: TextStyle(
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                  color: isDark
                      ? AppColors.darkSecondaryText.withOpacity(0.7)
                      : Colors.grey[400],
                  fontWeight: FontWeight.w400,
                ),
                errorStyle: TextStyle(
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                  color: isDark
                      ? AppColors.darkDestructive
                      : Colors.red[400],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 