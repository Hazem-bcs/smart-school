import 'package:flutter/material.dart';

/// AppColors class contains all color definitions for Smart School applications
/// This class provides a centralized place for all color management
/// Supports both light and dark themes with semantic color naming
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // ==================== PRIMARY COLORS ====================
  /// Primary brand color for Smart School
  static const Color primary = Color(0xFF6366F1);
  
  /// Secondary brand color for Smart School
  static const Color secondary = Color(0xFF8B5CF6);
  
  /// Accent color for highlights and special elements
  static const Color accent = Color(0xFF10B981);

  // ==================== SEMANTIC COLORS ====================
  /// Success color for positive actions and states
  static const Color success = Color(0xFF10B981);
  
  /// Warning color for caution states
  static const Color warning = Color(0xFFF59E0B);
  
  /// Error color for destructive actions and errors
  static const Color error = Color(0xFFEF4444);
  
  /// Info color for informational content
  static const Color info = Color(0xFF3B82F6);

  // ==================== NEUTRAL COLORS ====================
  /// Pure white
  static const Color white = Color(0xFFFFFFFF);
  
  /// Pure black
  static const Color black = Color(0xFF000000);
  
  /// Transparent color
  static const Color transparent = Color(0x00000000);

  // ==================== GRAY SCALE ====================
  /// Lightest gray
  static const Color gray50 = Color(0xFFF9FAFB);
  
  /// Very light gray
  static const Color gray100 = Color(0xFFF3F4F6);
  
  /// Light gray
  static const Color gray200 = Color(0xFFE5E7EB);
  
  /// Medium light gray
  static const Color gray300 = Color(0xFFD1D5DB);
  
  /// Medium gray
  static const Color gray400 = Color(0xFF9CA3AF);
  
  /// Medium dark gray
  static const Color gray500 = Color(0xFF6B7280);
  
  /// Dark gray
  static const Color gray600 = Color(0xFF4B5563);
  
  /// Very dark gray
  static const Color gray700 = Color(0xFF374151);
  
  /// Darkest gray
  static const Color gray800 = Color(0xFF1F2937);
  
  /// Almost black gray
  static const Color gray900 = Color(0xFF111827);

  // ==================== APP-SPECIFIC COLORS ====================
  /// Teacher app accent color (green)
  static const Color teacherAccent = Color(0xFF10B981);
  
  /// Student app accent color (blue)
  static const Color studentAccent = Color(0xFF3B82F6);
  
  /// Parent app accent color (orange)
  static const Color parentAccent = Color(0xFFF59E0B);

  // ==================== LIGHT THEME COLORS ====================
  /// Light theme background color
  static const Color lightBackground = Color(0xFFF7F7F7);
  
  /// Light theme surface color
  static const Color lightSurface = Color(0xFFFFFFFF);
  
  /// Light theme primary text color
  static const Color lightPrimaryText = Color(0xFF000000);
  
  /// Light theme secondary text color
  static const Color lightSecondaryText = Color(0xFF8A8A8E);
  
  /// Light theme icon color
  static const Color lightIcon = Color(0xFF3C3C43);
  
  /// Light theme divider color
  static const Color lightDivider = Color(0xFFE5E5EA);
  
  /// Light theme destructive color
  static const Color lightDestructive = Color(0xFFFF3B30);

  // ==================== DARK THEME COLORS ====================
  /// Dark theme background color - Modern dark blue gradient base
  static const Color darkBackground = Color(0xFF0A0E21);
  
  /// Dark theme surface color - Rich dark blue surface
  static const Color darkSurface = Color(0xFF1A1F35);
  
  /// Dark theme primary text color - Pure white for contrast
  static const Color darkPrimaryText = Color(0xFFFFFFFF);
  
  /// Dark theme secondary text color - Soft blue-gray
  static const Color darkSecondaryText = Color(0xFF94A3B8);
  
  /// Dark theme icon color - Bright blue-white
  static const Color darkIcon = Color(0xFFE2E8F0);
  
  /// Dark theme divider color - Subtle blue-gray divider
  static const Color darkDivider = Color(0xFF334155);
  
  /// Dark theme destructive color - Modern red
  static const Color darkDestructive = Color(0xFFEF4444);

  // ==================== DARK THEME ACCENT COLORS ====================
  /// Dark theme card background - Slightly lighter than surface
  static const Color darkCardBackground = Color(0xFF242B42);
  
  /// Dark theme elevated surface - For floating elements
  static const Color darkElevatedSurface = Color(0xFF2D3748);
  
  /// Dark theme gradient start - Deep purple-blue
  static const Color darkGradientStart = Color(0xFF4C1D95);
  
  /// Dark theme gradient end - Deep blue
  static const Color darkGradientEnd = Color(0xFF1E40AF);
  
  /// Dark theme accent blue - For highlights
  static const Color darkAccentBlue = Color(0xFF3B82F6);
  
  /// Dark theme accent purple - For special elements
  static const Color darkAccentPurple = Color(0xFF8B5CF6);
  
  /// Dark theme success green - For positive states
  static const Color darkSuccess = Color(0xFF10B981);
  
  /// Dark theme warning orange - For caution states
  static const Color darkWarning = Color(0xFFF59E0B);

  // ==================== UTILITY METHODS ====================
  
  /// Get color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
  
  /// Get primary color with opacity
  static Color primaryWithOpacity(double opacity) {
    return primary.withOpacity(opacity);
  }
  
  /// Get secondary color with opacity
  static Color secondaryWithOpacity(double opacity) {
    return secondary.withOpacity(opacity);
  }
  
  /// Get accent color with opacity
  static Color accentWithOpacity(double opacity) {
    return accent.withOpacity(opacity);
  }

  // ==================== THEME COLOR GETTERS ====================
  
  /// Get background color based on brightness
  static Color getBackgroundColor(Brightness brightness) {
    return brightness == Brightness.light ? lightBackground : darkBackground;
  }
  
  /// Get surface color based on brightness
  static Color getSurfaceColor(Brightness brightness) {
    return brightness == Brightness.light ? lightSurface : darkSurface;
  }
  
  /// Get primary text color based on brightness
  static Color getPrimaryTextColor(Brightness brightness) {
    return brightness == Brightness.light ? lightPrimaryText : darkPrimaryText;
  }
  
  /// Get secondary text color based on brightness
  static Color getSecondaryTextColor(Brightness brightness) {
    return brightness == Brightness.light ? lightSecondaryText : darkSecondaryText;
  }
  
  /// Get icon color based on brightness
  static Color getIconColor(Brightness brightness) {
    return brightness == Brightness.light ? lightIcon : darkIcon;
  }
  
  /// Get divider color based on brightness
  static Color getDividerColor(Brightness brightness) {
    return brightness == Brightness.light ? lightDivider : darkDivider;
  }
  
  /// Get destructive color based on brightness
  static Color getDestructiveColor(Brightness brightness) {
    return brightness == Brightness.light ? lightDestructive : darkDestructive;
  }
} 