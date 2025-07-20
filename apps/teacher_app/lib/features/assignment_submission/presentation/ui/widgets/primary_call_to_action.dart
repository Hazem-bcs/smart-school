import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/submission_bloc.dart';
import '../../blocs/submission_state.dart';
import '../../blocs/submission_event.dart';
import 'package:core/theme/index.dart';

class PrimaryCallToAction extends StatelessWidget {
  final String assignmentId;
  const PrimaryCallToAction({super.key, required this.assignmentId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return BlocBuilder<SubmissionBloc, SubmissionState>(
      builder: (context, state) {
        final isLoading = state is SubmissionLoading;
        final isErrorState = state is MarkAsGradedError;
        
        return ElevatedButton.icon(
          onPressed: isLoading
              ? null
              : () {
                  context.read<SubmissionBloc>().add(MarkAssignmentAsGraded(assignmentId));
                },
          icon: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Icon(isErrorState ? Icons.refresh : Icons.check_circle_outline),
          label: Text(
            isErrorState ? 'إعادة المحاولة' : 'Mark as Graded',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: isErrorState 
                ? (isDark ? AppColors.darkDestructive : AppColors.error)
                : (isDark ? AppColors.darkAccentBlue : AppColors.info),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: isDark ? 4 : 2,
          ),
        );
      },
    );
  }
} 