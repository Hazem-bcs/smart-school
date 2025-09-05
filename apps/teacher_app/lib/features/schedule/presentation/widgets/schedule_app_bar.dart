import 'package:flutter/material.dart';

class ScheduleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onRefresh;

  const ScheduleAppBar({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      title: Text(
        'الجدول الأسبوعي',
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : const Color(0xFF0E141B),
        ),
      ),
      automaticallyImplyLeading: false,
      backgroundColor: isDark ? const Color(0xFF1A1A2E) : const Color(0xFFF8F9FA),
      elevation: 0,
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: onRefresh,
          icon: Icon(
            Icons.refresh,
            color: isDark ? Colors.white : const Color(0xFF0E141B),
          ),
          tooltip: 'تحديث الجدول',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 