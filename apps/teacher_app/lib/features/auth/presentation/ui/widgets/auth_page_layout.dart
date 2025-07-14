import 'package:flutter/material.dart';
import '../../../../../core/responsive_widgets.dart';

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
            constraints: const BoxConstraints(maxWidth: 400),
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