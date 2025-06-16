import 'package:smart_school/features/teacher/presentation/widget/teacher_profile_card.dart';
import 'package:smart_school/widgets/app_exports.dart';

class TeachersPage extends StatefulWidget {
  const TeachersPage({super.key});

  @override
  State<TeachersPage> createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGround,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(AppStrings.teachers, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TeacherProfileCard(
              imageUrl: "assets/images/user.png",
              name: "name",
              onTap: () {
                Navigator.of(context).pushNamed('/teacherPage');
              },
            ),
          ],
        ),
      ),
    );
  }
}
