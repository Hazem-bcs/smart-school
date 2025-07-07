import 'package:flutter/material.dart';
import 'constants/app_colors.dart';
import 'constants/app_text_styles.dart';
import 'constants/app_spacing.dart';

/// AppTheme class provides comprehensive theme management for Smart School applications
/// This class combines colors, text styles, and spacing into complete theme objects
/// Supports both light and dark themes with automatic system theme detection
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // ==================== LIGHT THEME ====================
  
  /// Light theme for Smart School applications
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Color scheme
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.lightSurface,
      background: AppColors.lightBackground,
      error: AppColors.lightDestructive,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.lightPrimaryText,
      onBackground: AppColors.lightPrimaryText,
      onError: AppColors.white,
    ),
    
    // Scaffold
    scaffoldBackgroundColor: AppColors.lightBackground,
    
    // App bar theme
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightSurface,
      foregroundColor: AppColors.lightPrimaryText,
      elevation: AppSpacing.noElevation,
      centerTitle: true,
      titleTextStyle: AppTextStyles.h4.copyWith(
        color: AppColors.lightPrimaryText,
        fontWeight: AppTextStyles.semiBold,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.lightIcon,
        size: AppSpacing.baseIcon,
      ),
    ),
    
    // Card theme
    cardTheme: CardTheme(
      color: AppColors.lightSurface,
      elevation: AppSpacing.smElevation,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.baseBorderRadius,
      ),
      margin: AppSpacing.xsMargin,
    ),
    
    // Text theme
    textTheme: TextTheme(
      displayLarge: AppTextStyles.h1.copyWith(color: AppColors.lightPrimaryText),
      displayMedium: AppTextStyles.h2.copyWith(color: AppColors.lightPrimaryText),
      displaySmall: AppTextStyles.h3.copyWith(color: AppColors.lightPrimaryText),
      headlineLarge: AppTextStyles.h4.copyWith(color: AppColors.lightPrimaryText),
      headlineMedium: AppTextStyles.h5.copyWith(color: AppColors.lightPrimaryText),
      headlineSmall: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.lightPrimaryText,
        fontWeight: AppTextStyles.semiBold,
      ),
      titleLarge: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.lightPrimaryText,
        fontWeight: AppTextStyles.semiBold,
      ),
      titleMedium: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.lightPrimaryText,
        fontWeight: AppTextStyles.medium,
      ),
      titleSmall: AppTextStyles.bodySmall.copyWith(
        color: AppColors.lightPrimaryText,
        fontWeight: AppTextStyles.medium,
      ),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.lightPrimaryText),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.lightPrimaryText),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.lightSecondaryText),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.lightPrimaryText),
      labelMedium: AppTextStyles.labelMedium.copyWith(color: AppColors.lightPrimaryText),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: AppColors.lightSecondaryText),
    ),
    
    // Icon theme
    iconTheme: const IconThemeData(
      color: AppColors.lightIcon,
      size: AppSpacing.baseIcon,
    ),
    
    // Divider theme
    dividerTheme: const DividerThemeData(
      color: AppColors.lightDivider,
      thickness: 1.0,
      space: AppSpacing.base,
    ),
    
    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurface,
      border: OutlineInputBorder(
        borderRadius: AppSpacing.baseBorderRadius,
        borderSide: const BorderSide(color: AppColors.lightDivider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppSpacing.baseBorderRadius,
        borderSide: const BorderSide(color: AppColors.lightDivider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppSpacing.baseBorderRadius,
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.baseBorderRadius,
        borderSide: const BorderSide(color: AppColors.lightDestructive),
      ),
      contentPadding: AppSpacing.inputPadding,
      labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.lightSecondaryText),
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.lightSecondaryText),
    ),
    
    // Elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: AppSpacing.smElevation,
        padding: AppSpacing.buttonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.baseBorderRadius,
        ),
        textStyle: AppTextStyles.buttonPrimary,
      ),
    ),
    
    // Text button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: AppSpacing.buttonPaddingSmall,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.baseBorderRadius,
        ),
        textStyle: AppTextStyles.buttonSecondary,
      ),
    ),
    
    // Outlined button theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: AppSpacing.buttonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.baseBorderRadius,
        ),
        textStyle: AppTextStyles.buttonSecondary,
      ),
    ),
    
    // Switch theme
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary;
        }
        return AppColors.lightSecondaryText;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary.withOpacity(0.5);
        }
        return AppColors.lightDivider;
      }),
    ),
    
    // Dialog theme
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.lightSurface,
      elevation: AppSpacing.mdElevation,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.baseBorderRadius,
      ),
      titleTextStyle: AppTextStyles.h4.copyWith(
        color: AppColors.lightPrimaryText,
        fontWeight: AppTextStyles.bold,
      ),
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.lightSecondaryText,
      ),
    ),
    
    // Bottom sheet theme
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.lightSurface,
      elevation: AppSpacing.mdElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.baseRadius),
        ),
      ),
    ),
  );

  // ==================== DARK THEME ====================
  
  /// Dark theme for Smart School applications
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // Color scheme
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.darkSurface,
      background: AppColors.darkBackground,
      error: AppColors.darkDestructive,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.darkPrimaryText,
      onBackground: AppColors.darkPrimaryText,
      onError: AppColors.white,
    ),
    
    // Scaffold
    scaffoldBackgroundColor: AppColors.darkBackground,
    
    // App bar theme
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkPrimaryText,
      elevation: AppSpacing.noElevation,
      centerTitle: true,
      titleTextStyle: AppTextStyles.h4.copyWith(
        color: AppColors.darkPrimaryText,
        fontWeight: AppTextStyles.semiBold,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.darkIcon,
        size: AppSpacing.baseIcon,
      ),
    ),
    
    // Card theme
    cardTheme: CardTheme(
      color: AppColors.darkSurface,
      elevation: AppSpacing.smElevation,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.baseBorderRadius,
      ),
      margin: AppSpacing.xsMargin,
    ),
    
    // Text theme
    textTheme: TextTheme(
      displayLarge: AppTextStyles.h1.copyWith(color: AppColors.darkPrimaryText),
      displayMedium: AppTextStyles.h2.copyWith(color: AppColors.darkPrimaryText),
      displaySmall: AppTextStyles.h3.copyWith(color: AppColors.darkPrimaryText),
      headlineLarge: AppTextStyles.h4.copyWith(color: AppColors.darkPrimaryText),
      headlineMedium: AppTextStyles.h5.copyWith(color: AppColors.darkPrimaryText),
      headlineSmall: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.darkPrimaryText,
        fontWeight: AppTextStyles.semiBold,
      ),
      titleLarge: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.darkPrimaryText,
        fontWeight: AppTextStyles.semiBold,
      ),
      titleMedium: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.darkPrimaryText,
        fontWeight: AppTextStyles.medium,
      ),
      titleSmall: AppTextStyles.bodySmall.copyWith(
        color: AppColors.darkPrimaryText,
        fontWeight: AppTextStyles.medium,
      ),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.darkPrimaryText),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkPrimaryText),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.darkSecondaryText),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.darkPrimaryText),
      labelMedium: AppTextStyles.labelMedium.copyWith(color: AppColors.darkPrimaryText),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: AppColors.darkSecondaryText),
    ),
    
    // Icon theme
    iconTheme: const IconThemeData(
      color: AppColors.darkIcon,
      size: AppSpacing.baseIcon,
    ),
    
    // Divider theme
    dividerTheme: const DividerThemeData(
      color: AppColors.darkDivider,
      thickness: 1.0,
      space: AppSpacing.base,
    ),
    
    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      border: OutlineInputBorder(
        borderRadius: AppSpacing.baseBorderRadius,
        borderSide: const BorderSide(color: AppColors.darkDivider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppSpacing.baseBorderRadius,
        borderSide: const BorderSide(color: AppColors.darkDivider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppSpacing.baseBorderRadius,
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.baseBorderRadius,
        borderSide: const BorderSide(color: AppColors.darkDestructive),
      ),
      contentPadding: AppSpacing.inputPadding,
      labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkSecondaryText),
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkSecondaryText),
    ),
    
    // Elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: AppSpacing.smElevation,
        padding: AppSpacing.buttonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.baseBorderRadius,
        ),
        textStyle: AppTextStyles.buttonPrimary,
      ),
    ),
    
    // Text button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: AppSpacing.buttonPaddingSmall,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.baseBorderRadius,
        ),
        textStyle: AppTextStyles.buttonSecondary,
      ),
    ),
    
    // Outlined button theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: AppSpacing.buttonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.baseBorderRadius,
        ),
        textStyle: AppTextStyles.buttonSecondary,
      ),
    ),
    
    // Switch theme
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary;
        }
        return AppColors.darkSecondaryText;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary.withOpacity(0.5);
        }
        return AppColors.darkDivider;
      }),
    ),
    
    // Dialog theme
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.darkSurface,
      elevation: AppSpacing.mdElevation,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.baseBorderRadius,
      ),
      titleTextStyle: AppTextStyles.h4.copyWith(
        color: AppColors.darkPrimaryText,
        fontWeight: AppTextStyles.bold,
      ),
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.darkSecondaryText,
      ),
    ),
    
    // Bottom sheet theme
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.darkSurface,
      elevation: AppSpacing.mdElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.baseRadius),
        ),
      ),
    ),
  );

  // ==================== UTILITY METHODS ====================
  
  /// Get theme based on brightness
  static ThemeData getTheme(Brightness brightness) {
    return brightness == Brightness.light ? lightTheme : darkTheme;
  }
  
  /// Get theme based on system theme
  static ThemeData getSystemTheme() {
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return getTheme(brightness);
  }
  
  /// Create custom theme with app-specific accent color
  static ThemeData createAppTheme({
    required Brightness brightness,
    required Color accentColor,
  }) {
    final baseTheme = getTheme(brightness);
    
    return baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: accentColor,
        secondary: accentColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: AppColors.white,
          elevation: AppSpacing.smElevation,
          padding: AppSpacing.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.baseBorderRadius,
          ),
          textStyle: AppTextStyles.buttonPrimary,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentColor,
          padding: AppSpacing.buttonPaddingSmall,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.baseBorderRadius,
          ),
          textStyle: AppTextStyles.buttonSecondary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentColor,
          side: BorderSide(color: accentColor),
          padding: AppSpacing.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.baseBorderRadius,
          ),
          textStyle: AppTextStyles.buttonSecondary,
        ),
      ),
    );
  }
} 