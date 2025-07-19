import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ResponsiveHelper {
  // Screen breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Get screen type
  static ScreenType getScreenType(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return ScreenType.mobile;
    } else if (width < tabletBreakpoint) {
      return ScreenType.tablet;
    } else {
      return ScreenType.desktop;
    }
  }

  // Check if screen is mobile
  static bool isMobile(BuildContext context) {
    return getScreenType(context) == ScreenType.mobile;
  }

  // Check if screen is tablet
  static bool isTablet(BuildContext context) {
    return getScreenType(context) == ScreenType.tablet;
  }

  // Check if screen is desktop
  static bool isDesktop(BuildContext context) {
    return getScreenType(context) == ScreenType.desktop;
  }

  // Get responsive padding
  static EdgeInsets getScreenPadding(BuildContext context) {
    ScreenType screenType = getScreenType(context);
    switch (screenType) {
      case ScreenType.mobile:
        return EdgeInsets.all(4.w);
      case ScreenType.tablet:
        return EdgeInsets.all(6.w);
      case ScreenType.desktop:
        return EdgeInsets.all(8.w);
    }
  }

  // Get responsive horizontal padding
  static EdgeInsets getHorizontalPadding(BuildContext context) {
    ScreenType screenType = getScreenType(context);
    switch (screenType) {
      case ScreenType.mobile:
        return EdgeInsets.symmetric(horizontal: 4.w);
      case ScreenType.tablet:
        return EdgeInsets.symmetric(horizontal: 6.w);
      case ScreenType.desktop:
        return EdgeInsets.symmetric(horizontal: 8.w);
    }
  }

  // Get responsive spacing
  static double getSpacing(BuildContext context, {double mobile = 16, double tablet = 24, double desktop = 32}) {
    ScreenType screenType = getScreenType(context);
    switch (screenType) {
      case ScreenType.mobile:
        return mobile;
      case ScreenType.tablet:
        return tablet;
      case ScreenType.desktop:
        return desktop;
    }
  }

  // Get responsive font size
  static double getFontSize(BuildContext context, {double mobile = 14, double tablet = 16, double desktop = 18}) {
    ScreenType screenType = getScreenType(context);
    switch (screenType) {
      case ScreenType.mobile:
        return mobile;
      case ScreenType.tablet:
        return tablet;
      case ScreenType.desktop:
        return desktop;
    }
  }

  // Get responsive icon size
  static double getIconSize(BuildContext context, {double mobile = 24, double tablet = 28, double desktop = 32}) {
    ScreenType screenType = getScreenType(context);
    switch (screenType) {
      case ScreenType.mobile:
        return mobile;
      case ScreenType.tablet:
        return tablet;
      case ScreenType.desktop:
        return desktop;
    }
  }

  // Get responsive card elevation
  static double getCardElevation(BuildContext context) {
    ScreenType screenType = getScreenType(context);
    switch (screenType) {
      case ScreenType.mobile:
        return 2;
      case ScreenType.tablet:
        return 3;
      case ScreenType.desktop:
        return 4;
    }
  }

  // Get responsive border radius
  static double getBorderRadius(BuildContext context) {
    ScreenType screenType = getScreenType(context);
    switch (screenType) {
      case ScreenType.mobile:
        return 8;
      case ScreenType.tablet:
        return 12;
      case ScreenType.desktop:
        return 16;
    }
  }

  // Get responsive grid cross axis count
  static int getGridCrossAxisCount(BuildContext context) {
    ScreenType screenType = getScreenType(context);
    switch (screenType) {
      case ScreenType.mobile:
        return 2;
      case ScreenType.tablet:
        return 3;
      case ScreenType.desktop:
        return 4;
    }
  }

  // Get responsive list tile height
  static double getListTileHeight(BuildContext context) {
    ScreenType screenType = getScreenType(context);
    switch (screenType) {
      case ScreenType.mobile:
        return 56;
      case ScreenType.tablet:
        return 64;
      case ScreenType.desktop:
        return 72;
    }
  }

  // Get responsive button height
  static double getButtonHeight(BuildContext context) {
    ScreenType screenType = getScreenType(context);
    switch (screenType) {
      case ScreenType.mobile:
        return 48;
      case ScreenType.tablet:
        return 56;
      case ScreenType.desktop:
        return 64;
    }
  }

  // Get responsive app bar height
  static double getAppBarHeight(BuildContext context) {
    ScreenType screenType = getScreenType(context);
    switch (screenType) {
      case ScreenType.mobile:
        return kToolbarHeight;
      case ScreenType.tablet:
        return kToolbarHeight + 8;
      case ScreenType.desktop:
        return kToolbarHeight + 16;
    }
  }

  // Get responsive max width for content
  static double getMaxContentWidth(BuildContext context) {
    ScreenType screenType = getScreenType(context);
    switch (screenType) {
      case ScreenType.mobile:
        return double.infinity;
      case ScreenType.tablet:
        return 600;
      case ScreenType.desktop:
        return 800;
    }
  }

  // Get responsive aspect ratio for cards
  static double getCardAspectRatio(BuildContext context) {
    ScreenType screenType = getScreenType(context);
    switch (screenType) {
      case ScreenType.mobile:
        return 1.2;
      case ScreenType.tablet:
        return 1.4;
      case ScreenType.desktop:
        return 1.6;
    }
  }
}

enum ScreenType {
  mobile,
  tablet,
  desktop,
}

// Extension for responsive text styles
extension ResponsiveTextStyle on TextStyle {
  TextStyle responsive(BuildContext context, {
    double? mobileSize,
    double? tabletSize,
    double? desktopSize,
  }) {
    ScreenType screenType = ResponsiveHelper.getScreenType(context);
    double fontSize;
    
    switch (screenType) {
      case ScreenType.mobile:
        fontSize = mobileSize ?? this.fontSize ?? 14;
        break;
      case ScreenType.tablet:
        fontSize = tabletSize ?? this.fontSize ?? 16;
        break;
      case ScreenType.desktop:
        fontSize = desktopSize ?? this.fontSize ?? 18;
        break;
    }
    
    return copyWith(fontSize: fontSize);
  }
}

// Extension for responsive padding
extension ResponsivePadding on EdgeInsets {
  EdgeInsets responsive(BuildContext context) {
    return ResponsiveHelper.getScreenPadding(context);
  }
} 