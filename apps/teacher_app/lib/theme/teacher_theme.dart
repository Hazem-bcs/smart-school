import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';

/// Custom theme for Teacher App that inherits from core theme
/// with teacher-specific colors and customizations
class TeacherTheme {
  // Teacher-specific accent colors
  static const Color teacherPrimary = Color(0xFF2196F3);      // Blue
  static const Color teacherSecondary = Color(0xFF1976D2);    // Darker Blue
  static const Color teacherAccent = Color(0xFF64B5F6);       // Light Blue
  static const Color teacherSuccess = Color(0xFF4CAF50);      // Green
  static const Color teacherWarning = Color(0xFFFF9800);      // Orange
  static const Color teacherError = Color(0xFFF44336);        // Red
  static const Color teacherInfo = Color(0xFF00BCD4);         // Cyan

  // Teacher-specific surface colors
  static const Color teacherSurfaceLight = Color(0xFFF8FBFF);
  static const Color teacherSurfaceDark = Color(0xFF1A1A2E);

  // Teacher-specific text colors
  static const Color teacherTextPrimary = Color(0xFF1A1A1A);
  static const Color teacherTextSecondary = Color(0xFF666666);
  static const Color teacherTextDark = Color(0xFFE0E0E0);

  /// Create light theme for Teacher App
  static ThemeData get lightTheme {
    return AppTheme.createAppTheme(
      brightness: Brightness.light,
      accentColor: teacherPrimary,
    ).copyWith(
      // Customize color scheme for teacher app
      colorScheme: const ColorScheme.light(
        primary: teacherPrimary,
        secondary: teacherSecondary,
        tertiary: teacherAccent,
        surface: teacherSurfaceLight,
        background: Colors.white,
        error: teacherError,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: teacherTextPrimary,
        onBackground: teacherTextPrimary,
        onError: Colors.white,
      ),
      
      // Customize text theme
      textTheme: TextTheme(
        titleLarge: AppTextStyles.h1.copyWith(
          color: teacherTextPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: AppTextStyles.h3.copyWith(
          color: teacherTextPrimary,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: teacherTextPrimary,
        ),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: teacherTextSecondary,
        ),
        labelLarge: AppTextStyles.labelLarge.copyWith(
          color: teacherTextPrimary,
        ),
        labelMedium: AppTextStyles.labelMedium.copyWith(
          color: teacherTextSecondary,
        ),
        labelSmall: AppTextStyles.labelSmall.copyWith(
          color: teacherTextSecondary,
        ),
      ),

      // Customize app bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: teacherPrimary,
        foregroundColor: Colors.white,
        elevation: AppSpacing.smElevation,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h3.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: AppSpacing.baseIcon,
        ),
      ),

      // Customize card theme
      cardTheme: CardTheme(
        color: teacherSurfaceLight,
        elevation: AppSpacing.smElevation,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.baseBorderRadius,
        ),
        margin: EdgeInsets.zero,
      ),

      // Customize elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: teacherPrimary,
          foregroundColor: Colors.white,
          elevation: AppSpacing.smElevation,
          padding: AppSpacing.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.baseBorderRadius,
          ),
          textStyle: AppTextStyles.buttonPrimary.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Customize outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: teacherPrimary,
          side: const BorderSide(color: teacherPrimary),
          padding: AppSpacing.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.baseBorderRadius,
          ),
          textStyle: AppTextStyles.buttonPrimary.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Customize switch theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          }
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return teacherPrimary;
          }
          return Colors.grey.shade300;
        }),
      ),

      // Customize divider theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE0E0E0),
        thickness: 1,
        space: 1,
      ),

      // Customize input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.baseBorderRadius,
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.baseBorderRadius,
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.baseBorderRadius,
          borderSide: const BorderSide(color: teacherPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.baseBorderRadius,
          borderSide: const BorderSide(color: teacherError),
        ),
        contentPadding: AppSpacing.inputPadding,
      ),
    );
  }

  /// Create dark theme for Teacher App
  static ThemeData get darkTheme {
    return AppTheme.createAppTheme(
      brightness: Brightness.dark,
      accentColor: teacherAccent,
    ).copyWith(
      // Customize color scheme for teacher app
      colorScheme: const ColorScheme.dark(
        primary: teacherAccent,
        secondary: teacherPrimary,
        tertiary: teacherSecondary,
        surface: teacherSurfaceDark,
        background: Color(0xFF121212),
        error: teacherError,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: teacherTextDark,
        onBackground: teacherTextDark,
        onError: Colors.white,
      ),
      
      // Customize text theme
      textTheme: TextTheme(
        titleLarge: AppTextStyles.h1.copyWith(
          color: teacherTextDark,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: AppTextStyles.h3.copyWith(
          color: teacherTextDark,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: teacherTextDark,
        ),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: Colors.grey.shade400,
        ),
        labelLarge: AppTextStyles.labelLarge.copyWith(
          color: teacherTextDark,
        ),
        labelMedium: AppTextStyles.labelMedium.copyWith(
          color: Colors.grey.shade400,
        ),
        labelSmall: AppTextStyles.labelSmall.copyWith(
          color: Colors.grey.shade400,
        ),
      ),

      // Customize app bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: teacherSurfaceDark,
        foregroundColor: teacherTextDark,
        elevation: AppSpacing.smElevation,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h3.copyWith(
          color: teacherTextDark,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: teacherTextDark,
          size: AppSpacing.baseIcon,
        ),
      ),

      // Customize card theme
      cardTheme: CardTheme(
        color: teacherSurfaceDark,
        elevation: AppSpacing.smElevation,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.baseBorderRadius,
        ),
        margin: EdgeInsets.zero,
      ),

      // Customize elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: teacherAccent,
          foregroundColor: Colors.black,
          elevation: AppSpacing.smElevation,
          padding: AppSpacing.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.baseBorderRadius,
          ),
          textStyle: AppTextStyles.buttonPrimary.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Customize outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: teacherAccent,
          side: const BorderSide(color: teacherAccent),
          padding: AppSpacing.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.baseBorderRadius,
          ),
          textStyle: AppTextStyles.buttonPrimary.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Customize switch theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.black;
          }
          return Colors.grey.shade600;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return teacherAccent;
          }
          return Colors.grey.shade600;
        }),
      ),

      // Customize divider theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFF424242),
        thickness: 1,
        space: 1,
      ),

      // Customize input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade900,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.baseBorderRadius,
          borderSide: const BorderSide(color: Color(0xFF424242)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.baseBorderRadius,
          borderSide: const BorderSide(color: Color(0xFF424242)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.baseBorderRadius,
          borderSide: const BorderSide(color: teacherAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.baseBorderRadius,
          borderSide: const BorderSide(color: teacherError),
        ),
        contentPadding: AppSpacing.inputPadding,
      ),
    );
  }

  /// Get teacher-specific colors based on brightness
  static ColorScheme getColorScheme(Brightness brightness) {
    return brightness == Brightness.light
        ? const ColorScheme.light(
            primary: teacherPrimary,
            secondary: teacherSecondary,
            tertiary: teacherAccent,
            surface: teacherSurfaceLight,
            background: Colors.white,
            error: teacherError,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: teacherTextPrimary,
            onBackground: teacherTextPrimary,
            onError: Colors.white,
          )
        : const ColorScheme.dark(
            primary: teacherAccent,
            secondary: teacherPrimary,
            tertiary: teacherSecondary,
            surface: teacherSurfaceDark,
            background: Color(0xFF121212),
            error: teacherError,
            onPrimary: Colors.black,
            onSecondary: Colors.white,
            onSurface: teacherTextDark,
            onBackground: teacherTextDark,
            onError: Colors.white,
          );
  }
} 