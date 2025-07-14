import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/theme/index.dart';
import '../../blocs/submission_bloc.dart';
import '../../blocs/submission_event.dart';
import '../../blocs/submission_state.dart';
import '../widgets/image_carousel.dart';
import '../widgets/grading_form.dart';
import '../widgets/student_card.dart';
import '../widgets/student_response_card.dart';
import '../widgets/primary_call_to_action.dart';
import '../widgets/secondary_actions.dart';

class AssignmentSubmissionScreen extends StatelessWidget {
  final String assignmentId;
  const AssignmentSubmissionScreen({super.key, required this.assignmentId});

  @override
  Widget build(BuildContext context) {
    return _AssignmentSubmissionView(assignmentId: assignmentId);
  }
}

class _AssignmentSubmissionView extends StatefulWidget {
  final String assignmentId;
  const _AssignmentSubmissionView({required this.assignmentId});

  @override
  State<_AssignmentSubmissionView> createState() => _AssignmentSubmissionViewState();
}

class _AssignmentSubmissionViewState extends State<_AssignmentSubmissionView> {
  bool _wasGraded = false;

  @override
  void initState() {
    super.initState();
    // Load submission data when the page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubmissionBloc>().add(LoadSubmissionData(widget.assignmentId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: BlocListener<SubmissionBloc, dynamic>(
        listener: (context, state) {
          if (state is SubmissionDataLoaded) {
            // Track if current student was already graded
            final currentStudent = state.students[state.currentStudentIndex];
            _wasGraded = currentStudent.isGraded;
          } else if (state is SubmissionSuccess) {
            // Show different message based on whether it was an update or new grade
            final message = _wasGraded ? 'Grade updated successfully!' : 'Grade submitted successfully!';
            final icon = _wasGraded ? Icons.update : Icons.check_circle;
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(message)),
                  ],
                ),
                backgroundColor: isDark ? AppColors.darkSuccess : AppColors.success,
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          } else if (state is SubmissionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: isDark ? AppColors.darkDestructive : AppColors.error,
                duration: const Duration(seconds: 4),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: false,
              snap: false,
              expandedHeight: 120,
              backgroundColor: isDark ? AppColors.darkAccentBlue : AppColors.info,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              title: Text(
                'Assignment Submission',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark 
                          ? [AppColors.darkGradientStart, AppColors.darkGradientEnd]
                          : [AppColors.info, AppColors.primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const StudentCard(),
                      const SizedBox(height: 24),
                      const StudentResponseCard(),
                      const SizedBox(height: 24),
                      const ImageCarousel(),
                      const SizedBox(height: 24),
                      const GradingForm(),
                      const SizedBox(height: 32),
                      const PrimaryCallToAction(),
                      const SizedBox(height: 16),
                      const SecondaryActions(),
                      // Add bottom padding to prevent overflow
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 