import 'package:flutter/material.dart';

class SettingsLoadingState extends StatelessWidget {
  const SettingsLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: isDark ? const Color(0xFF6366F1) : const Color(0xFF5A67D8),
          ),
          const SizedBox(height: 16),
          Text(
            'جاري تسجيل الخروج...',
            style: theme.textTheme.titleMedium?.copyWith(
              color: isDark ? Colors.white70 : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
} 