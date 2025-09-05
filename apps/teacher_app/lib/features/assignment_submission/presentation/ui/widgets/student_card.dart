import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/theme/index.dart';
import 'package:teacher_app/features/assignment_submission/domain/entities/student_submission.dart';
import '../../blocs/submission_bloc.dart';
import '../../blocs/submission_state.dart';

class StudentCard extends StatelessWidget {
  const StudentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubmissionBloc, SubmissionState>(
      builder: (context, state) {
        if (state is SubmissionDataLoaded) {
          final student = state.students[state.currentStudentIndex];
          return _buildStudentCard(context, student);
        } else if (state is GradeSubmissionError) {
          // في حالة خطأ التصحيح، نعرض بيانات الطالب المحفوظة
          final student = state.students[state.currentStudentIndex];
          return _buildStudentCard(context, student);
        }
        
        return _buildLoadingCard(context);
      },
    );
  }

  Widget _buildStudentCard(BuildContext context, StudentSubmission student) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Card(
      elevation: isDark ? 4 : 2,
      color: isDark ? AppColors.darkCardBackground : AppColors.lightSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'الطالب: ${student.studentName}', 
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    )
                  ),
                ),
                if (student.isGraded)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSuccess : AppColors.success,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'تم التصحيح',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'أُرسل: ${_formatDate(student.submittedAt)}', 
              style: TextStyle(
                color: isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText
              )
            ),
            if (student.isGraded && student.grade != null) ...[
              const SizedBox(height: 8),
              Text(
                'الدرجة: ${student.grade}/100',
                style: TextStyle(
                  color: isDark ? AppColors.darkAccentBlue : AppColors.info,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Card(
      elevation: isDark ? 4 : 2,
      color: isDark ? AppColors.darkCardBackground : AppColors.lightSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 24,
              width: 200,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSecondaryText : AppColors.gray300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 16,
              width: 150,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSecondaryText : AppColors.gray300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
} 