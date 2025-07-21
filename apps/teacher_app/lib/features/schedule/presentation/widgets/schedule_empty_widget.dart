import 'package:flutter/material.dart';

class ScheduleEmptyWidget extends StatelessWidget {
  const ScheduleEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 64,
            color: isDark ? Colors.white54 : Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد دروس لهذا اليوم',
            style: theme.textTheme.titleMedium?.copyWith(
              color: isDark ? Colors.white54 : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اسحب للأسفل للتحديث',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.white38 : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
} 