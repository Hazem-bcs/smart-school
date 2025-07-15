import 'package:flutter/material.dart';
import '../../../../../core/responsive/responsive_helper.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime currentMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const CalendarHeader({
    super.key,
    required this.currentMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Padding(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onPreviousMonth,
            icon: Icon(
              Icons.chevron_left,
              color: isDark ? Colors.white : const Color(0xFF0E141B),
            ),
          ),
          Text(
            _getMonthYearString(),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0E141B),
            ),
          ),
          IconButton(
            onPressed: onNextMonth,
            icon: Icon(
              Icons.chevron_right,
              color: isDark ? Colors.white : const Color(0xFF0E141B),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthYearString() {
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    
    return '${months[currentMonth.month - 1]} ${currentMonth.year}';
  }
} 