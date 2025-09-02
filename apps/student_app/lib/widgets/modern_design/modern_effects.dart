import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';

/// Modern design effects helper class for glassmorphism, neumorphism, and other contemporary UI effects
class ModernEffects {
  ModernEffects._();

  // ==================== GLASSMORPHISM EFFECTS ====================
  
  /// Creates a glassmorphism effect container
  static Widget glassmorphism({
    required Widget child,
    required bool isDark,
    double opacity = 0.1,
    double blur = 10.0,
    double borderOpacity = 0.2,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: Border.all(
          color: isDark 
            ? AppColors.glassBorderDark.withOpacity(borderOpacity)
            : AppColors.glassBorderLight.withOpacity(borderOpacity),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark 
              ? AppColors.glassOverlayDark.withOpacity(0.1)
              : AppColors.glassOverlayLight.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: isDark 
                ? AppColors.darkCardBackground.withOpacity(opacity)
                : AppColors.white.withOpacity(opacity),
              borderRadius: borderRadius ?? BorderRadius.circular(16),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  // ==================== NEUMORPHISM EFFECTS ====================
  
  /// Creates a neumorphism effect container
  static Widget neumorphism({
    required Widget child,
    required bool isDark,
    double distance = 4.0,
    double intensity = 0.15,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    EdgeInsets? margin,
    bool isPressed = false,
  }) {
    final radius = borderRadius ?? BorderRadius.circular(16);
    final backgroundColor = isDark ? AppColors.darkCardBackground : AppColors.gray50;
    
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: radius,
        color: backgroundColor,
        boxShadow: isPressed
          ? [
              BoxShadow(
                color: isDark 
                  ? AppColors.neuDarkShadow.withOpacity(intensity * 0.5)
                  : AppColors.neuLightShadow.withOpacity(intensity * 0.5),
                offset: Offset(distance * 0.5, distance * 0.5),
                blurRadius: distance * 0.5,
              ),
            ]
          : [
              BoxShadow(
                color: isDark 
                  ? AppColors.neuDarkShadow.withOpacity(intensity)
                  : AppColors.neuLightShadow.withOpacity(intensity),
                offset: Offset(distance, distance),
                blurRadius: distance * 2,
              ),
              BoxShadow(
                color: isDark 
                  ? AppColors.neuHighlight.withOpacity(intensity * 0.5)
                  : AppColors.white.withOpacity(intensity * 2),
                offset: Offset(-distance, -distance),
                blurRadius: distance * 2,
              ),
            ],
      ),
      child: Container(
        padding: padding,
        child: child,
      ),
    );
  }

  // ==================== GRADIENT EFFECTS ====================
  
  /// Creates a modern gradient background
  static LinearGradient modernGradient({
    required bool isDark,
    GradientType type = GradientType.primary,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    List<Color> colors;
    
    switch (type) {
      case GradientType.primary:
        colors = isDark
          ? [AppColors.darkGradientStart, AppColors.darkGradientEnd]
          : [AppColors.primaryGradientStart, AppColors.primaryGradientEnd];
        break;
      case GradientType.secondary:
        colors = isDark
          ? [AppColors.darkAccentPurple, AppColors.darkAccentBlue]
          : [AppColors.secondaryGradientStart, AppColors.secondaryGradientEnd];
        break;
      case GradientType.success:
        colors = isDark
          ? [AppColors.darkSuccess, AppColors.accent]
          : [AppColors.success, AppColors.accent];
        break;
      case GradientType.warning:
        colors = isDark
          ? [AppColors.darkWarning, AppColors.warmGradientEnd]
          : [AppColors.warmGradientStart, AppColors.warmGradientEnd];
        break;
      case GradientType.cool:
        colors = isDark
          ? [AppColors.darkAccentBlue, AppColors.darkGradientEnd]
          : [AppColors.coolGradientStart, AppColors.coolGradientEnd];
        break;
    }
    
    return LinearGradient(
      begin: begin,
      end: end,
      colors: colors,
    );
  }

  // ==================== SHADOW EFFECTS ====================
  
  /// Creates modern shadow effects
  static List<BoxShadow> modernShadow({
    required bool isDark,
    ShadowType type = ShadowType.soft,
  }) {
    switch (type) {
      case ShadowType.soft:
        return [
          BoxShadow(
            color: isDark 
              ? AppColors.black.withOpacity(0.3)
              : AppColors.gray400.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ];
      case ShadowType.medium:
        return [
          BoxShadow(
            color: isDark 
              ? AppColors.black.withOpacity(0.4)
              : AppColors.gray400.withOpacity(0.15),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ];
      case ShadowType.strong:
        return [
          BoxShadow(
            color: isDark 
              ? AppColors.black.withOpacity(0.5)
              : AppColors.gray400.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ];
      case ShadowType.glow:
        return [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ];
    }
  }

  // ==================== ANIMATION CURVES ====================
  
  /// Modern animation curves
  static const Curve modernEase = Curves.easeOutCubic;
  static const Curve modernBounce = Curves.elasticOut;
  static const Curve modernSmooth = Curves.easeInOutCubic;
}

/// Gradient types for modern effects
enum GradientType {
  primary,
  secondary,
  success,
  warning,
  cool,
}

/// Shadow types for modern effects
enum ShadowType {
  soft,
  medium,
  strong,
  glow,
}
