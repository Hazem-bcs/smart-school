import 'package:flutter/material.dart';

/// AppSpacing class contains all spacing, padding, margins, and dimension definitions
/// This class provides a centralized place for all spacing management
/// Uses a consistent spacing scale for better design consistency
class AppSpacing {
  // Private constructor to prevent instantiation
  AppSpacing._();

  // ==================== SPACING SCALE ====================
  /// Extra extra small spacing (2px)
  static const double xxs = 2.0;
  
  /// Extra small spacing (4px)
  static const double xs = 4.0;
  
  /// Small spacing (8px)
  static const double sm = 8.0;
  
  /// Medium spacing (12px)
  static const double md = 12.0;
  
  /// Base spacing (16px)
  static const double base = 16.0;
  
  /// Large spacing (20px)
  static const double lg = 20.0;
  
  /// Extra large spacing (24px)
  static const double xl = 24.0;
  
  /// 2X large spacing (32px)
  static const double xl2 = 32.0;
  
  /// 3X large spacing (40px)
  static const double xl3 = 40.0;
  
  /// 4X large spacing (48px)
  static const double xl4 = 48.0;
  
  /// 5X large spacing (56px)
  static const double xl5 = 56.0;
  
  /// 6X large spacing (64px)
  static const double xl6 = 64.0;

  // ==================== PADDING ====================
  
  /// Extra small padding
  static const EdgeInsets xsPadding = EdgeInsets.all(xs);
  
  /// Small padding
  static const EdgeInsets smPadding = EdgeInsets.all(sm);
  
  /// Medium padding
  static const EdgeInsets mdPadding = EdgeInsets.all(md);
  
  /// Base padding
  static const EdgeInsets basePadding = EdgeInsets.all(base);
  
  /// Large padding
  static const EdgeInsets lgPadding = EdgeInsets.all(lg);
  
  /// Extra large padding
  static const EdgeInsets xlPadding = EdgeInsets.all(xl);

  // ==================== HORIZONTAL PADDING ====================
  
  /// Extra small horizontal padding
  static const EdgeInsets xsHorizontalPadding = EdgeInsets.symmetric(horizontal: xs);
  
  /// Small horizontal padding
  static const EdgeInsets smHorizontalPadding = EdgeInsets.symmetric(horizontal: sm);
  
  /// Medium horizontal padding
  static const EdgeInsets mdHorizontalPadding = EdgeInsets.symmetric(horizontal: md);
  
  /// Base horizontal padding
  static const EdgeInsets baseHorizontalPadding = EdgeInsets.symmetric(horizontal: base);
  
  /// Large horizontal padding
  static const EdgeInsets lgHorizontalPadding = EdgeInsets.symmetric(horizontal: lg);
  
  /// Extra large horizontal padding
  static const EdgeInsets xlHorizontalPadding = EdgeInsets.symmetric(horizontal: xl);

  // ==================== VERTICAL PADDING ====================
  
  /// Extra small vertical padding
  static const EdgeInsets xsVerticalPadding = EdgeInsets.symmetric(vertical: xs);
  
  /// Small vertical padding
  static const EdgeInsets smVerticalPadding = EdgeInsets.symmetric(vertical: sm);
  
  /// Medium vertical padding
  static const EdgeInsets mdVerticalPadding = EdgeInsets.symmetric(vertical: md);
  
  /// Base vertical padding
  static const EdgeInsets baseVerticalPadding = EdgeInsets.symmetric(vertical: base);
  
  /// Large vertical padding
  static const EdgeInsets lgVerticalPadding = EdgeInsets.symmetric(vertical: lg);
  
  /// Extra large vertical padding
  static const EdgeInsets xlVerticalPadding = EdgeInsets.symmetric(vertical: xl);

  // ==================== MARGIN ====================
  
  /// Extra small margin
  static const EdgeInsets xsMargin = EdgeInsets.all(xs);
  
  /// Small margin
  static const EdgeInsets smMargin = EdgeInsets.all(sm);
  
  /// Medium margin
  static const EdgeInsets mdMargin = EdgeInsets.all(md);
  
  /// Base margin
  static const EdgeInsets baseMargin = EdgeInsets.all(base);
  
  /// Large margin
  static const EdgeInsets lgMargin = EdgeInsets.all(lg);
  
  /// Extra large margin
  static const EdgeInsets xlMargin = EdgeInsets.all(xl);

  // ==================== HORIZONTAL MARGIN ====================
  
  /// Extra small horizontal margin
  static const EdgeInsets xsHorizontalMargin = EdgeInsets.symmetric(horizontal: xs);
  
  /// Small horizontal margin
  static const EdgeInsets smHorizontalMargin = EdgeInsets.symmetric(horizontal: sm);
  
  /// Medium horizontal margin
  static const EdgeInsets mdHorizontalMargin = EdgeInsets.symmetric(horizontal: md);
  
  /// Base horizontal margin
  static const EdgeInsets baseHorizontalMargin = EdgeInsets.symmetric(horizontal: base);
  
  /// Large horizontal margin
  static const EdgeInsets lgHorizontalMargin = EdgeInsets.symmetric(horizontal: lg);
  
  /// Extra large horizontal margin
  static const EdgeInsets xlHorizontalMargin = EdgeInsets.symmetric(horizontal: xl);

  // ==================== VERTICAL MARGIN ====================
  
  /// Extra small vertical margin
  static const EdgeInsets xsVerticalMargin = EdgeInsets.symmetric(vertical: xs);
  
  /// Small vertical margin
  static const EdgeInsets smVerticalMargin = EdgeInsets.symmetric(vertical: sm);
  
  /// Medium vertical margin
  static const EdgeInsets mdVerticalMargin = EdgeInsets.symmetric(vertical: md);
  
  /// Base vertical margin
  static const EdgeInsets baseVerticalMargin = EdgeInsets.symmetric(vertical: base);
  
  /// Large vertical margin
  static const EdgeInsets lgVerticalMargin = EdgeInsets.symmetric(vertical: lg);
  
  /// Extra large vertical margin
  static const EdgeInsets xlVerticalMargin = EdgeInsets.symmetric(vertical: xl);

  // ==================== SCREEN PADDING ====================
  
  /// Standard screen padding (16px horizontal, 24px vertical)
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: base,
    vertical: xl,
  );
  
  /// Compact screen padding (12px horizontal, 16px vertical)
  static const EdgeInsets screenPaddingCompact = EdgeInsets.symmetric(
    horizontal: md,
    vertical: base,
  );
  
  /// Wide screen padding (24px horizontal, 32px vertical)
  static const EdgeInsets screenPaddingWide = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: xl2,
  );

  // ==================== CARD PADDING ====================
  
  /// Standard card padding
  static const EdgeInsets cardPadding = EdgeInsets.all(base);
  
  /// Compact card padding
  static const EdgeInsets cardPaddingCompact = EdgeInsets.all(md);
  
  /// Wide card padding
  static const EdgeInsets cardPaddingWide = EdgeInsets.all(lg);

  // ==================== BUTTON PADDING ====================
  
  /// Standard button padding
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );
  
  /// Small button padding
  static const EdgeInsets buttonPaddingSmall = EdgeInsets.symmetric(
    horizontal: base,
    vertical: sm,
  );
  
  /// Large button padding
  static const EdgeInsets buttonPaddingLarge = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: lg,
  );

  // ==================== INPUT FIELD PADDING ====================
  
  /// Standard input field padding
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: base,
    vertical: md,
  );
  
  /// Compact input field padding
  static const EdgeInsets inputPaddingCompact = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  // ==================== BORDER RADIUS ====================
  
  /// Extra small border radius
  static const double xsRadius = 4.0;
  
  /// Small border radius
  static const double smRadius = 8.0;
  
  /// Medium border radius
  static const double mdRadius = 12.0;
  
  /// Base border radius
  static const double baseRadius = 16.0;
  
  /// Large border radius
  static const double lgRadius = 20.0;
  
  /// Extra large border radius
  static const double xlRadius = 24.0;
  
  /// Circular border radius
  static const double circularRadius = 50.0;

  // ==================== BORDER RADIUS OBJECTS ====================
  
  /// Extra small border radius
  static const BorderRadius xsBorderRadius = BorderRadius.all(Radius.circular(xsRadius));
  
  /// Small border radius
  static const BorderRadius smBorderRadius = BorderRadius.all(Radius.circular(smRadius));
  
  /// Medium border radius
  static const BorderRadius mdBorderRadius = BorderRadius.all(Radius.circular(mdRadius));
  
  /// Base border radius
  static const BorderRadius baseBorderRadius = BorderRadius.all(Radius.circular(baseRadius));
  
  /// Large border radius
  static const BorderRadius lgBorderRadius = BorderRadius.all(Radius.circular(lgRadius));
  
  /// Extra large border radius
  static const BorderRadius xlBorderRadius = BorderRadius.all(Radius.circular(xlRadius));
  
  /// Circular border radius
  static const BorderRadius circularBorderRadius = BorderRadius.all(Radius.circular(circularRadius));

  // ==================== ICON SIZES ====================
  
  /// Extra small icon size
  static const double xsIcon = 12.0;
  
  /// Small icon size
  static const double smIcon = 16.0;
  
  /// Medium icon size
  static const double mdIcon = 20.0;
  
  /// Base icon size
  static const double baseIcon = 24.0;
  
  /// Large icon size
  static const double lgIcon = 32.0;
  
  /// Extra large icon size
  static const double xlIcon = 40.0;
  
  /// 2X large icon size
  static const double xl2Icon = 48.0;

  // ==================== ELEVATION ====================
  
  /// No elevation
  static const double noElevation = 0.0;
  
  /// Extra small elevation
  static const double xsElevation = 1.0;
  
  /// Small elevation
  static const double smElevation = 2.0;
  
  /// Medium elevation
  static const double mdElevation = 4.0;
  
  /// Base elevation
  static const double baseElevation = 8.0;
  
  /// Large elevation
  static const double lgElevation = 16.0;
  
  /// Extra large elevation
  static const double xlElevation = 24.0;

  // ==================== UTILITY METHODS ====================
  
  /// Create custom padding
  static EdgeInsets padding({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    if (all != null) {
      return EdgeInsets.all(all);
    }
    return EdgeInsets.only(
      left: left ?? horizontal ?? 0,
      top: top ?? vertical ?? 0,
      right: right ?? horizontal ?? 0,
      bottom: bottom ?? vertical ?? 0,
    );
  }
  
  /// Create custom margin
  static EdgeInsets margin({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return padding(
      all: all,
      horizontal: horizontal,
      vertical: vertical,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
  }
  
  /// Create custom border radius
  static BorderRadius borderRadius({
    double? all,
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
  }) {
    if (all != null) {
      return BorderRadius.all(Radius.circular(all));
    }
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft ?? 0),
      topRight: Radius.circular(topRight ?? 0),
      bottomLeft: Radius.circular(bottomLeft ?? 0),
      bottomRight: Radius.circular(bottomRight ?? 0),
    );
  }
} 