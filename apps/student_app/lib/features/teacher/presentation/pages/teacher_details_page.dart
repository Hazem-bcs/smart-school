import 'package:core/theme/app_theme.dart';
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
    return Scaffold(
      appBar: AppBarWidget(title: AppStrings.teacherDetails),
      backgroundColor: backGround,
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
                    style: const TextStyle(color: Colors.red),
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
                        // قسم المعلومات الأساسية
                        _buildInfoCardsSection(loadedTeacher),
                        const SizedBox(height: 32),
                        // قسم السيرة الذاتية (Bio)
                        _buildBioSection(loadedTeacher),
                        const SizedBox(height: 32),
                        // قسم المواد الدراسية
                        _buildSubjectsSection(context, loadedTeacher),
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

  // دالة مساعدة لبناء قسم بطاقات المعلومات (الهاتف والعنوان)
  Widget _buildInfoCardsSection(TeacherEntity teacher) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Info',
          style: TextStyle(
            color: AppTheme.primary1,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                icon: Icons.phone_android,
                title: 'Phone',
                subtitle: teacher.phone.isNotEmpty ? teacher.phone : 'N/A',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoCard(
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

  // دالة مساعدة لبناء بطاقة معلومات فردية
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryColor, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لبناء قسم السيرة الذاتية
  Widget _buildBioSection(TeacherEntity teacher) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bio',
          style: TextStyle(
            color: AppTheme.primary1,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          teacher.description,
          style: TextStyle(
            color: tertiaryColor,
            fontSize: 16,
            fontWeight: FontWeight.normal,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // دالة مساعدة لبناء قسم المواد الدراسية
  Widget _buildSubjectsSection(BuildContext context, TeacherEntity teacher) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subjects',
          style: TextStyle(
            color:AppTheme.primary1 ,
            fontSize: 22,
            fontWeight: FontWeight.bold,
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
