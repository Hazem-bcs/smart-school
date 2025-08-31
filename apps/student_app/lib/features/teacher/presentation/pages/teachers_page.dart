
import 'package:smart_school/widgets/app_exports.dart';
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
    return Scaffold(
      backgroundColor: backGround,
      appBar: AppBarWidget(title: "Teachers"),
      body: BlocBuilder<TeacherListBloc, TeacherListState>(
        builder: (context, state) {
          if (state is TeacherListInitial || state is TeacherListLoading) {
            return const Center(child: AppLoadingWidget());
          }
          if (state is TeacherListError) {
            print('hi from teacher page');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TeacherListBloc>().add(
                        GetTeacherList(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              itemCount: teachers.length,
              itemBuilder: (context, index) {
                final TeacherEntity teacher = teachers[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TeacherProfileCard(
                    imageUrl: teacher.imageUrl,
                    name: teacher.name,
                    subject: "Math",
                    onTap: () {
                      context.goToTeacherDetails(teacher.id);
                    },
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}