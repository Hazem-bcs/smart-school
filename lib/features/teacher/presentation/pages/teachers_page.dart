import 'package:smart_school/features/teacher/presentation/widget/teacher_profile_card.dart';
import 'package:smart_school/widgets/app_exports.dart';

class TeachersPage extends StatefulWidget {
  const TeachersPage({super.key});

  @override
  State<TeachersPage> createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> {
  final List<Map<String, String>> teacherProfiles = [
    {
      'imageUrl': 'assets/images/user.png',
      'name': 'Teacher One',
    },
    {
      'imageUrl': 'assets/images/user_2.png',
      'name': 'Teacher Two',
    },
    {
      'imageUrl': 'assets/images/user_3.png',
      'name': 'Teacher Three',
    },
    {
      'imageUrl': 'assets/images/user_4.png',
      'name': 'Teacher Four',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGround,
      appBar:AppBarWidget(title: "Teachers"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:GridView.count(
          shrinkWrap: true,  // حتى ياخذ مساحة حسب المحتوى
          physics: NeverScrollableScrollPhysics(), // لمنع التمرير داخل عمود كبير
          crossAxisCount: 2,  // عدد الكروت في كل صف
          children: List.generate(
            teacherProfiles.length, // عدد العناصر (مصفوفة بيانات المعلمين مثلاً)
                (index) => TeacherProfileCard(
              imageUrl: teacherProfiles[index]['imageUrl']!,
              name: teacherProfiles[index]['name']!,
              onTap: () {
                Navigator.of(context).pushNamed('/teacherPage');
              },
            ),
          ),
        ),

        // Column(
        //   children: [
        //     TeacherProfileCard(
        //       imageUrl: "assets/images/user.png",
        //       name: "name",
        //       onTap: () {
        //         Navigator.of(context).pushNamed('/teacherPage');
        //       },
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
