import 'package:flutter/material.dart';

class ProfileTheme {
  // Colors from JSON
  static const Color background = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF181C2A);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF232946);
  static const Color primary = Color(0xFF4A90E2);
  static const Color secondary = Color(0xFF50E3C2);
  static const Color accentBlue = Color(0xFF3A86FF);
  static const Color accentGreen = Color(0xFF00B894);
  static const Color accentPurple = Color(0xFF6C63FF);
  static const Color accentOrange = Color(0xFFFFB86B);
  static const Color textPrimary = Color(0xFF101418);
  static const Color textPrimaryDark = Color(0xFFF8F9FA);
  static const Color textSecondary = Color(0xFF5C738A);
  static const Color textSecondaryDark = Color(0xFFB0B8C1);
  static const Color icon = Color(0xFF101418);
  static const Color iconDark = Color(0xFFF8F9FA);

  // Typography from JSON
  static TextStyle headline(BuildContext context) => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).brightness == Brightness.dark ? textPrimaryDark : textPrimary,
  );

  static TextStyle title(BuildContext context) => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).brightness == Brightness.dark ? textPrimaryDark : textPrimary,
  );

  static TextStyle body(BuildContext context) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).brightness == Brightness.dark ? textPrimaryDark : textPrimary,
  );

  static TextStyle caption(BuildContext context) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Theme.of(context).brightness == Brightness.dark ? textSecondaryDark : textSecondary,
  );

  // Card decoration
  static BoxDecoration cardDecoration(BuildContext context, {int colorIndex = 0}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List<Color> darkColors = [
      surfaceDark,
      Color(0xFF232946),
      Color(0xFF22223B),
      Color(0xFF2D3250),
      Color(0xFF1A2A32),
      accentBlue.withOpacity(0.18),
      accentGreen.withOpacity(0.18),
      accentPurple.withOpacity(0.18),
      accentOrange.withOpacity(0.18),
    ];
    return BoxDecoration(
      color: isDark ? darkColors[colorIndex % darkColors.length] : surface,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: isDark ? Colors.black.withOpacity(0.18) : Colors.black.withOpacity(0.05),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  // Button styles
  static ButtonStyle primaryButtonStyle(BuildContext context) => ElevatedButton.styleFrom(
    backgroundColor: primary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
  );

  static ButtonStyle secondaryButtonStyle(BuildContext context) => OutlinedButton.styleFrom(
    foregroundColor: primary,
    side: const BorderSide(color: primary),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );
} 