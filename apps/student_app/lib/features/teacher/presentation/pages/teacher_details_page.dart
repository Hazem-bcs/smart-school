import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/widgets/app_exports.dart';
import 'package:teacher_feat/domain/teacher_entity.dart';
import 'package:smart_school/features/teacher/presentation/blocs/teacher_details_bloc.dart';

import '../../../subject/presentation/pages/subject_details_page.dart';

class TeacherDetailsPage extends StatefulWidget {
  final int teacherId;
  final TeacherEntity? teacher;

  const TeacherDetailsPage({super.key, required this.teacherId, this.teacher});

  @override
  State<TeacherDetailsPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherDetailsPage> {
  @override
  void initState() {
    context.read<TeacherDetailsBloc>().add(
      GetTeacherById(teacherId: widget.teacherId),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBarWidget(title: AppStrings.teacherDetails),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<TeacherDetailsBloc, TeacherDetailsState>(
        builder: (context, state) {
          if (state is TeacherDetailsInitial ||
              state is TeacherDetailsLoading) {
            return const Center(child: AppLoadingWidget());
          }
          if (state is TeacherDetailsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: TextStyle(color: theme.colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TeacherDetailsBloc>().add(
                        GetTeacherById(teacherId: widget.teacherId),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: theme
                          .elevatedButtonTheme
                          .style
                          ?.foregroundColor
                          ?.resolve({MaterialState.pressed}),
                      backgroundColor: theme
                          .elevatedButtonTheme
                          .style
                          ?.backgroundColor
                          ?.resolve({MaterialState.pressed}),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Retry',
                      style: theme.elevatedButtonTheme.style?.textStyle
                          ?.resolve({MaterialState.pressed}),
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is TeacherDetailsLoaded) {
            final TeacherEntity loadedTeacher = state.teacher;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoCardsSection(loadedTeacher, theme),
                        const SizedBox(height: 32),
                        _buildBioSection(loadedTeacher, theme),
                        const SizedBox(height: 32),
                        _buildSubjectsSection(context, loadedTeacher, theme),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const Text("Unknown State");
        },
      ),
    );
  }

  Widget _buildInfoCardsSection(TeacherEntity teacher, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Info',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                theme: theme,
                icon: Icons.phone_android,
                title: 'Phone',
                subtitle: teacher.phone.isNotEmpty ? teacher.phone : 'N/A',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoCard(
                theme: theme,
                icon: Icons.location_on,
                title: 'Address',
                subtitle: teacher.address.isNotEmpty ? teacher.address : 'N/A',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.hintColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildBioSection(TeacherEntity teacher, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bio',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          teacher.description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.hintColor,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectsSection(
    BuildContext context,
    TeacherEntity teacher,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subjects',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        if (teacher.subjects.isNotEmpty)
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.75,
            ),
            itemCount: teacher.subjects.length,
            itemBuilder: (context, index) {
              final subject = teacher.subjects[index];
              return AppSubjectCard(
                subject: subject,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              SubjectDetailsPage(subjectId: subject.id),
                    ),
                  );
                },
              );
            },
          )
        else
          const Center(child: Text("No subjects found for this teacher.")),
      ],
    );
  }
}
