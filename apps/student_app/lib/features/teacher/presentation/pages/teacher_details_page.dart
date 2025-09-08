import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/widgets/app_exports.dart';
import 'package:core/widgets/unified_loading_indicator.dart';
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

  Widget _buildHeader(TeacherEntity teacher, ThemeData theme) {
    final colors = _gradientFor(teacher.name);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          AppAvatarWidget(imageUrl: teacher.imageUrl, radius: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teacher.name,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _pill(icon: Icons.phone_android, label: teacher.phone.isNotEmpty ? teacher.phone : 'لا يوجد هاتف'),
                    _pill(icon: Icons.location_on, label: teacher.address.isNotEmpty ? teacher.address : 'لا يوجد عنوان'),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _gradientFor(String name) {
    final palettes = <List<Color>>[
      [const Color(0xFF7B61FF), const Color(0xFF5E2EFF)],
      [const Color(0xFF00C6FF), const Color(0xFF0072FF)],
      [const Color(0xFFFF6CAB), const Color(0xFF7366FF)],
      [const Color(0xFFFFA726), const Color(0xFFFF7043)],
      [const Color(0xFF42E695), const Color(0xFF3BB2B8)],
    ];
    final index = name.hashCode.abs() % palettes.length;
    return palettes[index];
  }

  Widget _pill({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBarWidget(
        title: 'تفاصيل المعلم',
        actions: [
          AppBarActions.refresh(
            onPressed: () {
              context.read<TeacherDetailsBloc>().add(
                GetTeacherById(teacherId: widget.teacherId),
              );
            },
            isDark: Theme.of(context).brightness == Brightness.dark,
          ),
        ],
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<TeacherDetailsBloc, TeacherDetailsState>(
        builder: (context, state) {
          if (state is TeacherDetailsInitial ||
              state is TeacherDetailsLoading) {
            return const Center(child: SmartSchoolLoading(message: 'جاري تحميل بيانات المعلم...'));
          }
          if (state is TeacherDetailsError) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TeacherDetailsBloc>().add(
                  GetTeacherById(teacherId: widget.teacherId),
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height,
                  child: Center(
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
                  ),
                ),
              ),
            );
          }
          if (state is TeacherDetailsLoaded) {
            final TeacherEntity loadedTeacher = state.teacher;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TeacherDetailsBloc>().add(
                  GetTeacherById(teacherId: widget.teacherId),
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                          _buildHeader(loadedTeacher, theme),
                          const SizedBox(height: 24),
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