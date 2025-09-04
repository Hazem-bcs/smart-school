import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';
import 'package:homework/domain/entites/homework_entity.dart';

class HomeworkCardWidget extends StatelessWidget {
  final HomeworkEntity homework;
  final int index;
  final bool isDark;
  final VoidCallback onTap;

  const HomeworkCardWidget({
    super.key,
    required this.homework,
    required this.index,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getSubjectColor(index).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark ? AppColors.darkDivider.withOpacity(0.3) : AppColors.gray200,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          splashColor: _getSubjectColor(index).withOpacity(0.1),
          highlightColor: _getSubjectColor(index).withOpacity(0.05),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(homework.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getStatusText(homework.status),
                          style: TextStyle(
                            color: _getStatusColor(homework.status),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _getSubjectColor(index).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _getSubjectIcon(homework.subject),
                        color: _getSubjectColor(index),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        homework.subject,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkPrimaryText : AppColors.gray800,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: isDark ? AppColors.darkSecondaryText : AppColors.gray500,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _formatDate(homework.dueDate),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkSecondaryText : AppColors.gray500,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getSubjectColor(index),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'بدء الواجب',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'تم التسليم':
        return const Color(0xFF10B981);
      case 'pending':
      case 'قيد الانتظار':
        return const Color(0xFFF59E0B);
      case 'overdue':
      case 'متأخر':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'تم التسليم':
        return 'تم التسليم';
      case 'pending':
      case 'قيد الانتظار':
        return 'قيد الانتظار';
      case 'overdue':
      case 'متأخر':
        return 'متأخر';
      default:
        return 'غير محدد';
    }
  }

  Color _getSubjectColor(int index) {
    final colors = [
      const Color(0xFF4F46E5),
      const Color(0xFF7C3AED),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFF06B6D4),
    ];
    return colors[index % colors.length];
  }

  IconData _getSubjectIcon(String subject) {
    final subjectLower = subject.toLowerCase();
    if (subjectLower.contains('رياضيات') || subjectLower.contains('math')) {
      return Icons.calculate;
    } else if (subjectLower.contains('علوم') || subjectLower.contains('science')) {
      return Icons.science;
    } else if (subjectLower.contains('لغة') || subjectLower.contains('language')) {
      return Icons.language;
    } else if (subjectLower.contains('تاريخ') || subjectLower.contains('history')) {
      return Icons.history_edu;
    } else if (subjectLower.contains('جغرافيا') || subjectLower.contains('geography')) {
      return Icons.public;
    } else if (subjectLower.contains('حاسوب') || subjectLower.contains('computer')) {
      return Icons.computer;
    } else {
      return Icons.book;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference < 0) {
      return 'متأخر';
    } else if (difference == 0) {
      return 'اليوم';
    } else if (difference == 1) {
      return 'غداً';
    } else if (difference <= 7) {
      return 'خلال $difference أيام';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
