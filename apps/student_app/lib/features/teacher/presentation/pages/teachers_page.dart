import 'package:smart_school/features/teacher/presentation/pages/teacher_details_page.dart';
import 'package:smart_school/widgets/app_exports.dart';

class TeachersPage extends StatefulWidget {
  const TeachersPage({super.key});

  @override
  State<TeachersPage> createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> {
  final List<Map<String, dynamic>> teacherProfiles = [
    {
      "id":1,
      'imageUrl': 'assets/images/user.png',
      'name': 'Teacher One',
    },
    {
      "id":2,
      'imageUrl': 'assets/images/user_2.png',
      'name': 'Teacher Two',
    },
    {
      "id":3,
      'imageUrl': 'assets/images/user_3.png',
      'name': 'Teacher Three',
    },
    {
      "id":4,
      'imageUrl': 'assets/images/user_4.png',
      'name': 'Teacher Four',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGround,
      appBar: AppBarWidget(title: "Teachers"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          children: List.generate(
            teacherProfiles.length,
                (index) =>
                TeacherProfileCard(
                  imageUrl: teacherProfiles[index]['imageUrl']!,
                  name: teacherProfiles[index]['name']!,
                  onTap: () {
                //     Navigator.of(context).pushReplacement(MaterialPageRoute(
                //       builder: (context) =>
                //           TeacherDetailsPage(teacherId: teacherProfiles[index]['id'], teacher:),));
                 },
                ),
          ),
        ),
      ),
    );
  }
}
