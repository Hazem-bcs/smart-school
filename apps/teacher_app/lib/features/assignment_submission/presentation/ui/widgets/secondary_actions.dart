import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/theme/index.dart';
import '../../blocs/submission_bloc.dart';
import '../../blocs/submission_state.dart';
import '../../blocs/submission_event.dart';

class SecondaryActions extends StatelessWidget {
  const SecondaryActions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubmissionBloc, SubmissionState>(
      builder: (context, state) {
        if (state is SubmissionDataLoaded) {
          return _buildNavigationButtons(context, state);
        } else if (state is GradeSubmissionError) {
          // في حالة خطأ التصحيح، نعرض أزرار التنقل مع البيانات المحفوظة
          return _buildNavigationButtons(context, state);
        }
        
        return _buildLoadingButtons(context);
      },
    );
  }

  Widget _buildNavigationButtons(BuildContext context, dynamic state) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Column(
      children: [
        // Student counter
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'الطالب ${state.currentStudentIndex + 1} من ${state.students.length}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
            ),
          ),
        ),
        // Navigation buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: state.hasPreviousStudent 
                    ? () => context.read<SubmissionBloc>().add(NavigateToPreviousStudent())
                    : null,
                icon: Icon(Icons.navigate_before),
                label: const Text('السابق'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: state.hasPreviousStudent 
                        ? (isDark ? AppColors.darkAccentBlue : AppColors.info)
                        : (isDark ? AppColors.darkSecondaryText : AppColors.gray300),
                  ),
                  foregroundColor: state.hasPreviousStudent 
                      ? (isDark ? AppColors.darkAccentBlue : AppColors.info)
                      : (isDark ? AppColors.darkSecondaryText : AppColors.gray400),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: state.hasNextStudent 
                    ? () => context.read<SubmissionBloc>().add(NavigateToNextStudent())
                    : null,
                icon: Icon(Icons.navigate_next),
                label: const Text('التالي'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: state.hasNextStudent 
                        ? (isDark ? AppColors.darkAccentBlue : AppColors.info)
                        : (isDark ? AppColors.darkSecondaryText : AppColors.gray300),
                  ),
                  foregroundColor: state.hasNextStudent 
                      ? (isDark ? AppColors.darkAccentBlue : AppColors.info)
                      : (isDark ? AppColors.darkSecondaryText : AppColors.gray400),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingButtons(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Column(
      children: [
        Container(
          height: 16,
          width: 120,
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSecondaryText : AppColors.gray300,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSecondaryText : AppColors.gray300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSecondaryText : AppColors.gray300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
} 