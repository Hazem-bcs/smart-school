import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/widgets/app_exports.dart';
import 'package:core/widgets/unified_loading_indicator.dart';
import 'package:teacher_feat/domain/teacher_entity.dart';
import 'package:smart_school/routing/navigation_extension.dart';
import '../blocs/teacher_list_bloc.dart';

class TeachersPage extends StatefulWidget {
  const TeachersPage({super.key});

  @override
  State<TeachersPage> createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> {
  @override
  void initState() {
    super.initState();
    context.read<TeacherListBloc>().add(GetTeacherList());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: "المعلمون",
        actions: [
          AppBarActions.refresh(
            onPressed: () {
              context.read<TeacherListBloc>().add(GetTeacherList());
            },
            isDark: theme.brightness == Brightness.dark,
          ),
        ],
      ),
      body: BlocBuilder<TeacherListBloc, TeacherListState>(
        builder: (context, state) {
          if (state is TeacherListInitial || state is TeacherListLoading) {
            return CommonLoadingStates.dataLoading();
          }
          if (state is TeacherListError) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TeacherListBloc>().add(GetTeacherList());
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
                            context.read<TeacherListBloc>().add(GetTeacherList());
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
          if (state is TeacherListLoaded) {
            final List<TeacherEntity> teachers = state.teacherList;

            if (teachers.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<TeacherListBloc>().add(GetTeacherList());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height,
                    child: const Center(
                        child: Text('لا توجد بيانات للمعلمين.')),
                  ),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TeacherListBloc>().add(GetTeacherList());
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                itemCount: teachers.length,
                itemBuilder: (context, index) {
                  final TeacherEntity teacher = teachers[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: TeacherProfileCard(
                      imageUrl: teacher.imageUrl,
                      name: teacher.name,
                      subject: teacher.subjects.isNotEmpty ? teacher.subjects.first.name : 'بدون تخصّص',
                      onTap: () {
                        context.goToTeacherDetails(teacher.id);
                      },
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}