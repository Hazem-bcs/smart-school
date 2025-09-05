import 'package:flutter/material.dart';
import '../../../domain/entities/assignment_entity.dart';
import '../../../../../core/responsive/responsive_helper.dart';
import 'assignment_tile.dart';

class AssignmentsSection extends StatelessWidget {
  final List<AssignmentEntity> assignments;
  final void Function(AssignmentEntity assignment)? onTap;

  const AssignmentsSection({
    super.key,
    required this.assignments,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
          child: Text(
            'واجبات غير مصححة',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: assignments.length,
          itemBuilder: (context, index) {
            final a = assignments[index];
            return AssignmentTile(
              title: a.title,
              subtitle: a.subtitle,
              icon: Icons.assignment_late,
              index: index,
              onTap: onTap == null ? null : () => onTap!(a),
            );
          },
        ),
      ],
    );
  }
}


