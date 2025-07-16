import 'package:flutter/material.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'section_title.dart';
import 'decorated_section_container.dart';
import 'action_tile.dart';

class NewAssignmentDueDateSection extends StatelessWidget {
  final bool isDark;
  final String dueDateText;
  final VoidCallback onSelectDateAndTime;
  const NewAssignmentDueDateSection({Key? key, required this.isDark, required this.dueDateText, required this.onSelectDateAndTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Due Date & Time', icon: Icons.schedule, iconColor: isDark ? AppColors.warning : AppColors.warning),
        DecoratedSectionContainer(
          isDark: isDark,
          child: ActionTile(
            icon: Icons.event_available,
            text: dueDateText,
            onTap: onSelectDateAndTime,
            iconColor: isDark ? AppColors.warning : AppColors.warning,
          ),
        ),
      ],
    );
  }
} 