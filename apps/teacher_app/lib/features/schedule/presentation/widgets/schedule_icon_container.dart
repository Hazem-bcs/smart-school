import 'package:flutter/material.dart';

class ScheduleIconContainer extends StatelessWidget {
  final IconData icon;
  final bool isDark;

  const ScheduleIconContainer({
    super.key,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isDark 
            ? const Color(0xFF2A2A3E) 
            : const Color(0xFFE7EDF3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: isDark 
            ? const Color(0xFF4A90E2)
            : const Color(0xFF4A90E2),
        size: 24,
      ),
    );
  }
} 