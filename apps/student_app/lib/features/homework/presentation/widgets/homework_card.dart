import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:homework/data/models/homework_model.dart';
import 'package:homework/domain/entites/homework_entity.dart';
import 'package:smart_school/features/homework/presentation/pages/one_homework_page.dart';

class HomeworkCard extends StatelessWidget {
  final HomeworkEntity homework;

  const HomeworkCard({super.key, required this.homework});

  IconData _getSubjectIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'رياضيات':
        return Icons.calculate;
      case 'علوم':
        return Icons.science_outlined;
      case 'تاريخ':
        return Icons.history_edu;
      case 'لغة عربية':
        return Icons.translate;
      default:
        return Icons.assignment;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor =
        homework.status == HomeworkStatus.pending
            ? Colors.orangeAccent
            : Colors.green;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OneHomeworkPage(questionId: 1),
          ),
        );
      },
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 10.0,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subject and Icon
                      Row(
                        children: [
                          Icon(
                            _getSubjectIcon(homework.subject),
                            color: Theme.of(context).primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            homework.subject,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Homework Title
                      Text(
                        homework.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.3, // لتحسين المسافة بين السطور
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Spacer(), // لدفع التاريخ إلى الأسفل
                      // Due Date
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'تاريخ الاستحقاق: ${DateFormat.yMMMd('ar').format(homework.dueDate)}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}
