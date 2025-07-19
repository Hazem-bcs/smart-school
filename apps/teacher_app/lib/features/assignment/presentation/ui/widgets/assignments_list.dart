import 'package:flutter/material.dart';
import 'package:teacher_app/features/assignment/domain/entities/assignment.dart';
import '../../../../../core/responsive/responsive_helper.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'assignment_list_tile.dart';

class AssignmentsList extends StatelessWidget {
  final List<Assignment> assignments;
  final bool isDark;
  final Function(Assignment) onAssignmentTap;
  final VoidCallback onRefresh;

  const AssignmentsList({
    super.key,
    required this.assignments,
    required this.isDark,
    required this.onAssignmentTap,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
          vertical: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
        ),
        itemCount: assignments.length,
        separatorBuilder: (context, index) => SizedBox(
          height: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20),
        ),
        itemBuilder: (context, index) {
          final assignment = assignments[index];
          return Card(
            color: isDark ? AppColors.darkCardBackground : theme.cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            shadowColor: isDark ? Colors.black.withOpacity(0.15) : Colors.grey.withOpacity(0.08),
            margin: EdgeInsets.zero,
            child: AssignmentListTile(
              title: assignment.title,
              subtitle: assignment.subtitle,
              isCompleted: assignment.isCompleted,
              index: index,
              onTap: () => onAssignmentTap(assignment),
            ),
          );
        },
      ),
    );
  }
} 