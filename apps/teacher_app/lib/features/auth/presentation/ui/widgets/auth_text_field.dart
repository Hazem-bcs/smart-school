import 'package:flutter/material.dart';
import '../../../../../core/responsive/responsive_helper.dart';
import '../../../../../core/responsive/responsive_widgets.dart';

/// Widget متجاوب لحقول الإدخال في صفحات المصادقة
class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool enabled;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: ResponsiveIcon(
          prefixIcon,
          mobileSize: 20,
          tabletSize: 24,
          desktopSize: 28,
        ),
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: ResponsiveIcon(
                  suffixIcon!,
                  mobileSize: 20,
                  tabletSize: 24,
                  desktopSize: 28,
                ),
                onPressed: onSuffixIconPressed,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context)),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context)),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context)),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context)),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getSpacing(context),
          vertical: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20),
        ),
        labelStyle: TextStyle(
          fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 18),
        ),
      ),
      style: TextStyle(
        fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 18),
      ),
      validator: validator,
    );
  }
} 