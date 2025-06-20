import 'package:smart_school/widgets/app_exports.dart';

class AppDrawerWidget extends StatelessWidget {
  const AppDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          DrawerItem(
            onTap: () {
              Navigator.of(context).pushNamed('/teachersPage');
            },
            imageUrl: "imageUrl",
            title: AppStrings.teachers,
            icon: Icons.person,
          ),
          SizedBox(height: 10),
          DrawerItem(
            onTap: () {
              Navigator.of(context).pushNamed(   '/homeWorkPage');
            },
            imageUrl: "imageUrl",
            title: AppStrings.homeWork,
            icon: Icons.home_work,
          ),
        ],
      ),
    );
  }
}
