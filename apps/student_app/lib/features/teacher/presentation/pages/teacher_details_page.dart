
import 'package:smart_school/features/subject/presentation/blocs/subject_list/subject_list_bloc.dart';
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
    context.read<SubjectListBloc>().add(GetSubjectListEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGround,
      appBar: AppBar(
        title: Text(
          AppStrings.teacherDetails,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
        elevation: 4,
      ),
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
                  Text('Error loading subject: ${state.message}'),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TeacherDetailsBloc>().add(
                        GetTeacherById(teacherId: widget.teacherId),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is TeacherDetailsLoaded) {
            final TeacherEntity loadedTeacher = state.teacher;
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppBarImageWidget(
                    title: loadedTeacher.name,
                    height: 200,
                    isImage: true,
                    imageName: loadedTeacher.imageUrl,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        //bio
                        Align(
                          alignment: Alignment.centerLeft,
                          child: AppTextWidget(
                            text: AppStrings.bio,
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        //subject
                        Align(
                          alignment: Alignment.centerLeft,
                          child: AppTextWidget(
                            text: loadedTeacher.description,
                            style: TextStyle(
                              color: tertiaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: AppTextWidget(
                            text: AppStrings.subjects,
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        BlocBuilder<SubjectListBloc, SubjectListState>(
                          builder: (context, state) {
                            if (state is SubjectListLoading) {
                              return AppLoadingWidget();
                            }
                            if (state is SubjectListLoaded) {
                              if (state.subjectEntityList.isNotEmpty) {
                                return GridView.builder(
                                  padding: const EdgeInsets.all(16.0),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),

                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 16.0,
                                        mainAxisSpacing: 16.0,
                                        childAspectRatio: 0.75,
                                      ),
                                  itemCount: state.subjectEntityList.length,
                                  itemBuilder: (context, index) {
                                    final subject =
                                        state.subjectEntityList[index];
                                    return LayoutBuilder(
                                      builder: (context, constraints) {
                                        return ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minHeight: constraints.maxHeight,
                                            maxHeight: constraints.maxHeight,
                                            minWidth: constraints.maxWidth,
                                            maxWidth: constraints.maxWidth,
                                          ),
                                          child: AppSubjectCard(
                                            subject: subject,
                                            onTap: () {
                                              Navigator.of(
                                                context,
                                              ).pushReplacement(
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          SubjectDetailsPage(
                                                            subjectId:
                                                                subject.id,
                                                          ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              } else {
                                return const Center(
                                  child: Text("No subjects found."),
                                );
                              }
                            }

                            if (state is SubjectListFailure) {
                              return Center(
                                child: Text("Error: ${state.message}"),
                              );
                            }
                            return const Center(
                              child: Text("Initial state or no data."),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Text("data");
        },
      ),
    );
  }
}
