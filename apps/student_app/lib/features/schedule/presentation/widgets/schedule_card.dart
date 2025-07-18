import 'package:flutter/material.dart';
import '../../../../widgets/responsive/responsive_helper.dart';
import '../../domain/entities/schedule_entity.dart';

class ScheduleCard extends StatelessWidget {
  final String id;
  final IconData icon;
  final String title;
  final String subtitle;
  final ScheduleStatus status;
  final VoidCallback? onTap;

  const ScheduleCard({
    super.key,
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
          child: Row(
            children: [
              _buildIconContainer(theme, isDark),
              SizedBox(width: ResponsiveHelper.getSpacing(context)),
              Expanded(
                child: _buildContent(context, theme, isDark),
              ),
              _buildStatusIndicator(context, theme, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer(ThemeData theme, bool isDark) {
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

  Widget _buildContent(BuildContext context, ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF0E141B),
          ),
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 2, tablet: 4, desktop: 6)),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF4E7397),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator(BuildContext context, ThemeData theme, bool isDark) {
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