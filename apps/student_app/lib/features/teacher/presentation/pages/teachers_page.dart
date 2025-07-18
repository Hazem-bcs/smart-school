import 'package:smart_school/features/teacher/presentation/pages/teacher_details_page.dart';
import 'package:smart_school/widgets/app_exports.dart';
import 'package:teacher_feat/domain/teacher_entity.dart';

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
    context.read<TeacherListBloc>().add(GetTeacherList(studentId: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGround,
      appBar: AppBarWidget(title: "Teachers"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<TeacherListBloc, TeacherListState>(
          builder: (context, state) {
            if (state is TeacherListInitial || state is TeacherListLoading) {
              return const Center(child: AppLoadingWidget());
            }
            if (state is TeacherListError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error${state.message}'),

                    ElevatedButton(
                      onPressed: () {
                        context.read<TeacherListBloc>().add(
                          GetTeacherList(studentId: 1),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            if (state is TeacherListLoaded) {
              final List<TeacherEntity> teachers = state.teacherList;

              if (teachers.isEmpty) {
                return const Center(child: Text('لا توجد بيانات للمعلمين.'));
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.8,
                ),
                itemCount: teachers.length,

                itemBuilder: (context, index) {
                  final TeacherEntity teacher = teachers[index];

                  return TeacherProfileCard(
                    imageUrl: teacher.imageUrl,
                    name: teacher.name,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => TeacherDetailsPage(
                                teacherId: teacher.id,
                                teacher: teacher,
                              ),
                        ),
                      );
                    },
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
