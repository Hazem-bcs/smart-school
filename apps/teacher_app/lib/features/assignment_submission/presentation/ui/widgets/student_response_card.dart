import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/theme/index.dart';
import 'package:teacher_app/features/assignment_submission/domain/entities/student_submission.dart';
import '../../blocs/submission_bloc.dart';
import '../../blocs/submission_state.dart';

class StudentResponseCard extends StatelessWidget {
  const StudentResponseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubmissionBloc, SubmissionState>(
      builder: (context, state) {
        if (state is SubmissionDataLoaded) {
          final student = state.students[state.currentStudentIndex];
          return _buildResponseCard(context, student);
        } else if (state is GradeSubmissionError) {
          // في حالة خطأ التصحيح، نعرض بيانات الطالب المحفوظة
          final student = state.students[state.currentStudentIndex];
          return _buildResponseCard(context, student);
        }
        
        return _buildLoadingCard(context);
      },
    );
  }

  Widget _buildResponseCard(BuildContext context, StudentSubmission student) {
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
            Text(
              'إجابة الطالب', 
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              )
            ),
            const SizedBox(height: 12),
            Text(
              student.response,
              style: TextStyle(
                fontSize: 16, 
                height: 1.5,
                color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
            ),
            if (student.feedback != null && student.feedback!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkElevatedSurface : AppColors.gray50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? AppColors.darkAccentBlue : AppColors.info,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'التعليق:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkAccentBlue : AppColors.info,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      student.feedback!,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                      ),
                    ),
                  ],
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
              height: 20,
              width: 150,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSecondaryText : AppColors.gray300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 16,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSecondaryText : AppColors.gray300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 16,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSecondaryText : AppColors.gray300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 16,
              width: 200,
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
} 