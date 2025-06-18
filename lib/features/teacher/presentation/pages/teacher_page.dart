import 'package:smart_school/widgets/app_exports.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({super.key});

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGround,
      appBar: AppBar(
        title: Text(AppStrings.teacherDetails,style: TextStyle(color: Colors.white),),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppBarImageWidget(
            title: "name",
            height: 200,
            isImage: true,
            imageName: "assets/images/user.png",
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppTextWidget(
                    text: AppStrings.glimpse,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppTextWidget(
                    text: "خريج كلية الهندسة المعلوماتية",
                    style: TextStyle(
                      color: tertiaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppTextWidget(
                    text: AppStrings.subjects,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: AppSubjectCard(
                    nameSubject: 'math',
                    onTap: () {},
                    level: "التاسع",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
