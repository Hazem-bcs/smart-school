import 'package:flutter/material.dart';

class ScheduleRefreshWrapper extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const ScheduleRefreshWrapper({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: isDark ? const Color(0xFF6366F1) : const Color(0xFF5A67D8),
      backgroundColor: isDark ? const Color(0xFF1A1F35) : Colors.white,
      strokeWidth: 3.0,
      child: child,
    );
  }
} 