import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive_helper.dart';
import '../../domain/entities/schedule_entity.dart';

class ScheduleStatusIndicator extends StatelessWidget {
  final ScheduleStatus status;
  final bool isDark;

  const ScheduleStatusIndicator({
    super.key,
    required this.status,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    IconData statusIcon;
    Color statusColor;
    
    switch (status) {
      case ScheduleStatus.upcoming:
        statusIcon = Icons.schedule;
        statusColor = isDark ? const Color(0xFF4A90E2) : const Color(0xFF4A90E2);
        break;
      case ScheduleStatus.ongoing:
        statusIcon = Icons.play_circle_outline;
        statusColor = isDark ? const Color(0xFF4CAF50) : const Color(0xFF4CAF50);
        break;
      case ScheduleStatus.completed:
        statusIcon = Icons.check_circle_outline;
        statusColor = isDark ? const Color(0xFF4CAF50) : const Color(0xFF4CAF50);
        break;
    }
    
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 4, tablet: 6, desktop: 8)),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        statusIcon,
        color: statusColor,
        size: 20,
      ),
    );
  }
} 