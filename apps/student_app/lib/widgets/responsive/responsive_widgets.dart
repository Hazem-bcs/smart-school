import 'package:flutter/material.dart';
import 'responsive_helper.dart';

/// Widget متجاوب للبطاقات
class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final double? elevation;
  final double? borderRadius;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.elevation,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: elevation ?? ResponsiveHelper.getCardElevation(context),
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? ResponsiveHelper.getBorderRadius(context),
        ),
      ),
      child: Padding(
        padding: padding ?? ResponsiveHelper.getScreenPadding(context),
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          borderRadius ?? ResponsiveHelper.getBorderRadius(context),
        ),
        child: card,
      );
    }

    return card;
  }
}

/// Widget متجاوب للنصوص
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final double? mobileSize;
  final double? tabletSize;
  final double? desktopSize;
  final int? maxLines;
  final TextOverflow? overflow;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.mobileSize,
    this.tabletSize,
    this.desktopSize,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: (style ?? const TextStyle()).responsive(
        context,
        mobileSize: mobileSize,
        tabletSize: tabletSize,
        desktopSize: desktopSize,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Widget متجاوب للأيقونات
class ResponsiveIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double? mobileSize;
  final double? tabletSize;
  final double? desktopSize;

  const ResponsiveIcon(
    this.icon, {
    super.key,
    this.color,
    this.mobileSize,
    this.tabletSize,
    this.desktopSize,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: ResponsiveHelper.getIconSize(
        context,
        mobile: mobileSize ?? 24,
        tablet: tabletSize ?? 28,
        desktop: desktopSize ?? 32,
      ),
      color: color,
    );
  }
}

/// Widget متجاوب للمسافات
class ResponsiveSpacing extends StatelessWidget {
  final double? mobile;
  final double? tablet;
  final double? desktop;
  final bool isHorizontal;

  const ResponsiveSpacing({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveHelper.getSpacing(
      context,
      mobile: mobile ?? 16,
      tablet: tablet ?? 24,
      desktop: desktop ?? 32,
    );

    return isHorizontal
        ? SizedBox(width: spacing)
        : SizedBox(height: spacing);
  }
}

/// Widget متجاوب للأزرار
class ResponsiveButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? mobileWidth;
  final double? tabletWidth;
  final double? desktopWidth;

  const ResponsiveButton(
    this.text, {
    super.key,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.mobileWidth,
    this.tabletWidth,
    this.desktopWidth,
  });

  @override
  Widget build(BuildContext context) {
    final buttonWidth = ResponsiveHelper.isMobile(context)
        ? mobileWidth ?? 120
        : ResponsiveHelper.isTablet(context)
            ? tabletWidth ?? 150
            : desktopWidth ?? 180;

    return SizedBox(
      width: buttonWidth,
      height: ResponsiveHelper.getButtonHeight(context),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              ResponsiveIcon(icon!),
              ResponsiveSpacing(mobile: 8, tablet: 12, desktop: 16, isHorizontal: true),
            ],
            ResponsiveText(
              text,
              mobileSize: 14,
              tabletSize: 16,
              desktopSize: 18,
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget متجاوب للقوائم
class ResponsiveListTile extends StatelessWidget {
  final IconData? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;

  const ResponsiveListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading != null
          ? ResponsiveIcon(
              leading!,
              color: iconColor,
            )
          : null,
      title: ResponsiveText(
        title,
        mobileSize: 14,
        tabletSize: 16,
        desktopSize: 18,
        style: TextStyle(color: textColor),
      ),
      subtitle: subtitle != null
          ? ResponsiveText(
              subtitle!,
              mobileSize: 12,
              tabletSize: 14,
              desktopSize: 16,
              style: TextStyle(color: textColor?.withOpacity(0.7)),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(context),
        vertical: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
      ),
      minVerticalPadding: ResponsiveHelper.getListTileHeight(context) / 2,
    );
  }
}

/// Widget متجاوب للحاويات
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? borderRadius;
  final double? elevation;
  final BoxBorder? border;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.elevation,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? ResponsiveHelper.getScreenPadding(context),
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          borderRadius ?? ResponsiveHelper.getBorderRadius(context),
        ),
        border: border,
        boxShadow: elevation != null
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: elevation!,
                  offset: Offset(0, elevation! / 2),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}

/// Widget متجاوب للشبكات
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final double? childAspectRatio;
  final EdgeInsetsGeometry? padding;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.childAspectRatio,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context),
      crossAxisSpacing: crossAxisSpacing ?? ResponsiveHelper.getSpacing(context),
      mainAxisSpacing: mainAxisSpacing ?? ResponsiveHelper.getSpacing(context),
      childAspectRatio: childAspectRatio ?? ResponsiveHelper.getCardAspectRatio(context),
      padding: padding ?? ResponsiveHelper.getScreenPadding(context),
      children: children,
    );
  }
}

/// Widget متجاوب للمحتوى المحدود العرض
class ResponsiveContent extends StatelessWidget {
  final Widget child;
  final double? maxWidth;

  const ResponsiveContent({
    super.key,
    required this.child,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? ResponsiveHelper.getMaxContentWidth(context),
        ),
        child: child,
      ),
    );
  }
}

/// Widget متجاوب للتبديل بين التخطيطات
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context) && desktop != null) {
      return desktop!;
    } else if (ResponsiveHelper.isTablet(context) && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
} 