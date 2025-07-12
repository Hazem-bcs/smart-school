import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/responsive_helper.dart';
import '../../../../../core/responsive_widgets.dart';

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

/// Widget متجاوب لبطاقات المصادقة
class AuthCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double? elevation;

  const AuthCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation ?? ResponsiveHelper.getCardElevation(context),
      color: backgroundColor ?? Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context)),
      ),
      child: Padding(
        padding: padding ?? ResponsiveHelper.getScreenPadding(context),
        child: child,
      ),
    );
  }
}

/// Widget متجاوب لشعار المصادقة
class AuthLogo extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double? mobileSize;
  final double? tabletSize;
  final double? desktopSize;

  const AuthLogo(
    this.icon, {
    super.key,
    this.color,
    this.mobileSize,
    this.tabletSize,
    this.desktopSize,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveIcon(
      icon,
      mobileSize: mobileSize ?? 80,
      tabletSize: tabletSize ?? 100,
      desktopSize: desktopSize ?? 120,
      color: color ?? Theme.of(context).primaryColor,
    );
  }
}

/// Widget متجاوب لعناوين المصادقة
class AuthTitle extends StatelessWidget {
  final String text;
  final Color? color;
  final double? mobileSize;
  final double? tabletSize;
  final double? desktopSize;

  const AuthTitle(
    this.text, {
    super.key,
    this.color,
    this.mobileSize,
    this.tabletSize,
    this.desktopSize,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveText(
      text,
      mobileSize: mobileSize ?? 24,
      tabletSize: tabletSize ?? 28,
      desktopSize: desktopSize ?? 32,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: color ?? Theme.of(context).primaryColor,
      ),
      textAlign: TextAlign.center,
    );
  }
}

/// Widget متجاوب للنصوص الفرعية في المصادقة
class AuthSubtitle extends StatelessWidget {
  final String text;
  final Color? color;
  final double? mobileSize;
  final double? tabletSize;
  final double? desktopSize;

  const AuthSubtitle(
    this.text, {
    super.key,
    this.color,
    this.mobileSize,
    this.tabletSize,
    this.desktopSize,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveText(
      text,
      mobileSize: mobileSize ?? 14,
      tabletSize: tabletSize ?? 16,
      desktopSize: desktopSize ?? 18,
      style: TextStyle(
        color: color ?? Colors.grey[600],
      ),
      textAlign: TextAlign.center,
    );
  }
}

/// Widget متجاوب لتخطيط صفحة المصادقة
class AuthPageLayout extends StatelessWidget {
  final Widget logo;
  final Widget title;
  final Widget? subtitle;
  final Widget form;
  final Widget? additionalContent;

  const AuthPageLayout({
    super.key,
    required this.logo,
    required this.title,
    this.subtitle,
    required this.form,
    this.additionalContent,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
      desktop: _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        logo,
        ResponsiveSpacing(mobile: 32, tablet: 40, desktop: 48),
        title,
        if (subtitle != null) ...[
          ResponsiveSpacing(mobile: 16, tablet: 20, desktop: 24),
          subtitle!,
        ],
        ResponsiveSpacing(mobile: 48, tablet: 56, desktop: 64),
        form,
        if (additionalContent != null) ...[
          ResponsiveSpacing(mobile: 24, tablet: 32, desktop: 40),
          additionalContent!,
        ],
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              logo,
              ResponsiveSpacing(mobile: 32, tablet: 40, desktop: 48),
              title,
              if (subtitle != null) ...[
                ResponsiveSpacing(mobile: 16, tablet: 20, desktop: 24),
                subtitle!,
              ],
            ],
          ),
        ),
        ResponsiveSpacing(mobile: 0, tablet: 48, desktop: 64, isHorizontal: true),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              form,
              if (additionalContent != null) ...[
                ResponsiveSpacing(mobile: 24, tablet: 32, desktop: 40),
                additionalContent!,
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              logo,
              ResponsiveSpacing(mobile: 32, tablet: 40, desktop: 48),
              title,
              if (subtitle != null) ...[
                ResponsiveSpacing(mobile: 16, tablet: 20, desktop: 24),
                subtitle!,
              ],
            ],
          ),
        ),
        ResponsiveSpacing(mobile: 0, tablet: 48, desktop: 80, isHorizontal: true),
        Expanded(
          flex: 1,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                form,
                if (additionalContent != null) ...[
                  ResponsiveSpacing(mobile: 24, tablet: 32, desktop: 40),
                  additionalContent!,
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
} 