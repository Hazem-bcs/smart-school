import 'package:flutter/material.dart';
import '../../../../../core/responsive/responsive_helper.dart';
import '../../../../../core/responsive/responsive_widgets.dart';

/// Widget متجاوب لأزرار المصادقة
class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;

  const AuthButton(
    this.text, {
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final buttonWidth = width ?? (ResponsiveHelper.isMobile(context) ? double.infinity : 200);

    return SizedBox(
      width: buttonWidth,
      height: ResponsiveHelper.getButtonHeight(context),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context)),
          ),
          elevation: ResponsiveHelper.getCardElevation(context),
        ),
        child: isLoading
            ? SizedBox(
                width: ResponsiveHelper.getIconSize(context, mobile: 20, tablet: 24, desktop: 28),
                height: ResponsiveHelper.getIconSize(context, mobile: 20, tablet: 24, desktop: 28),
                child: CircularProgressIndicator(
                  strokeWidth: ResponsiveHelper.isMobile(context) ? 2 : 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? Colors.white,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    ResponsiveIcon(
                      icon!,
                      mobileSize: 18,
                      tabletSize: 20,
                      desktopSize: 22,
                      color: textColor ?? Colors.white,
                    ),
                    ResponsiveSpacing(mobile: 8, tablet: 12, desktop: 16, isHorizontal: true),
                  ],
                  ResponsiveText(
                    text,
                    mobileSize: 14,
                    tabletSize: 16,
                    desktopSize: 18,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: textColor ?? Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
} 