// lib/presentation/widgets/assignment_card.dart
import 'package:flutter/material.dart';
import '../../domain/entities/assignment_entity.dart';

class AssignmentCard extends StatelessWidget {
  final AssignmentEntity assignment;
  final VoidCallback onTap;

  const AssignmentCard({
    super.key,
    required this.assignment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد لون الشارة الجانبية بناءً على حالة المهمة
    Color statusColor = Colors.transparent;
    if (assignment.submissionStatus == SubmissionStatus.graded) {
      statusColor = Colors.green;
    } else {
      // كل ما هو غير "graded" يعتبر "notSubmitted" (أي "ungraded")
      statusColor = Colors.blue; // لون لـ "غير مصححة"
    }

    // تحديد إذا كانت المهمة جديدة (خلال 48 ساعة من الإنشاء)
    final isNew = DateTime.now().difference(assignment.createdAt).inHours <= 48;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            // الشارة الجانبية للحالة
            Container(
              width: 6,
              height: 80,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // عنوان المهمة
                        Expanded(
                          child: Text(
                            assignment.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // إيموجي المهمة الجديدة
                        if (isNew)
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text('🆕', style: TextStyle(fontSize: 20)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // حالة المهمة أو العلامة
                    Text(
                      _getStatusText(),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // تاريخ التسليم
                    Text(
                      'Due: ${_formatDate(assignment.dueDate)}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText() {
    switch (assignment.submissionStatus) {
      case SubmissionStatus.notSubmitted:
        return 'Not Graded';
      case SubmissionStatus.graded:
        return 'Graded: ${assignment.grade}/${assignment.points}';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
