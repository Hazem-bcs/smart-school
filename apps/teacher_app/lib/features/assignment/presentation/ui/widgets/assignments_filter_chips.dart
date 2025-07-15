import 'package:flutter/material.dart';
import 'package:teacher_app/features/assignment/domain/entities/assignment.dart';
import '../widgets/filter_chip.dart' as custom;
import '../../../../../core/responsive/responsive_helper.dart';

class AssignmentsFilterChips extends StatelessWidget {
  final List<Map<String, dynamic>> filterOptions;
  final AssignmentStatus selectedFilter;
  final ValueChanged<AssignmentStatus> onChanged;

  const AssignmentsFilterChips({
    super.key,
    required this.filterOptions,
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveHelper.getSpacing(context, mobile: 50, tablet: 60, desktop: 70),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getSpacing(context),
        ),
        itemCount: filterOptions.length,
        itemBuilder: (context, index) {
          final option = filterOptions[index];
          final isSelected = selectedFilter == option['status'];
          return custom.FilterChip(
            label: option['label'],
            isSelected: isSelected,
            onTap: () => onChanged(option['status']),
          );
        },
      ),
    );
  }
} 