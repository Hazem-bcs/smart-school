import 'package:sizer/sizer.dart';
import 'package:smart_school/features/subject/presentation/blocs/subject_list/subject_list_bloc.dart';
import 'package:smart_school/features/teacher/presentation/blocs/teacher_bloc.dart';
import 'package:smart_school/widgets/app_exports.dart';
import 'package:teacher_feat/domain/teacher_entity.dart';

class TeacherDetailsPage extends StatefulWidget {
  final int teacherId;
  final TeacherEntity teacher;

  const TeacherDetailsPage({
    super.key,
    required this.teacherId,
    required this.teacher,
  });

  @override
  State<TeacherDetailsPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherDetailsPage> {
  @override
  void initState() {
    context.read<TeacherBloc>().add(
      GetTeacherById(teacherId: widget.teacherId),
    );
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
      body: BlocBuilder(
        builder: (context, state) {
          if (state is TeacherInitial || state is GetDataLoadingState) {
            return const Center(child: AppLoadingWidget());
          }
          if (state is ErrorState ) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error loading subject: ${state.message}'),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TeacherBloc>().add(
                        GetTeacherList( studentId: widget.teacherId),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is TeacherListLoadedState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppBarImageWidget(
                    title: "name",
                    height: 200,
                    isImage: true,
                    imageName: widget.teacher.imageUrl ??"assets/images/user.png",
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: AppTextWidget(
                            text: AppStrings.bio,
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: AppTextWidget(
                            text: widget.teacher.description,
                            style: TextStyle(
                              color: tertiaryColor,
                              fontSize: 16.sp,
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
                              fontSize: 26.sp,
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
                                return AppSubjectCard(
                                  subject: state.subjectEntityList.first,
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
