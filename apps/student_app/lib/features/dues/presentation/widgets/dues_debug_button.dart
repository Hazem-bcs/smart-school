import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';
import 'package:core/theme/constants/app_colors.dart';
import '../pages/test_dues_connection_page.dart';

/// Widget لزر اختبار الاتصال (للتصحيح فقط)
class DuesDebugButton extends StatelessWidget {
  const DuesDebugButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TestDuesConnectionPage(),
            ),
          );
        },
        icon: const Icon(Icons.bug_report),
        label: const Text('اختبار الاتصال'),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? AppColors.darkWarning : AppColors.warning,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
    );
  }
}
