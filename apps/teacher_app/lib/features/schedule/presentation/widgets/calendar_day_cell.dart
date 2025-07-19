import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive_helper.dart';

class CalendarDayCell extends StatelessWidget {
  final int dayNumber;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  const CalendarDayCell({
    super.key,
    required this.dayNumber,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF4A90E2) : const Color(0xFF4A90E2))
              : isToday
                  ? (isDark ? const Color(0xFF2A2A3E) : const Color(0xFFE7EDF3))
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isToday && !isSelected
              ? Border.all(
                  color: isDark ? const Color(0xFF4A90E2) : const Color(0xFF4A90E2),
                  width: 2,
                )
              : null,
        ),
        child: Center(
          child: Text(
            dayNumber.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? Colors.white
                  : isDark
                      ? Colors.white
                      : const Color(0xFF0E141B),
            ),
          ),
        ),
      ),
    );
  }
} 