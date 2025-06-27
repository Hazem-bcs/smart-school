import 'package:core/domain/entities/subject_entity.dart';
import 'package:core/theme/constants/app_strings.dart';
import 'package:core/theme/constants/colors.dart';
import 'package:smart_school/widgets/app_exports.dart';

class TeacherDetailsPage extends StatefulWidget {
  const TeacherDetailsPage({super.key});

  @override
  State<TeacherDetailsPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherDetailsPage> {

  @override
  void initState() {
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppBarImageWidget(
              title: "name",
              height: 200,
              isImage: true,
              imageName: "assets/images/user.png",
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
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AppTextWidget(
                      text: "خريج كلية الهندسة المعلوماتية",
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
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: AppSubjectCard(
                      subject:  SubjectEntity(id: 1, name: '', image: '',),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}