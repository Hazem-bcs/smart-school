import 'package:smart_school/widgets/app_exports.dart';

class AppDrawerWidget extends StatelessWidget {
  const AppDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: secondaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          DrawerItem(
            onTap: () {
              Navigator.of(context).pushNamed('/teachersPage');
            },
            imageUrl:  "assets/svg/profile.svg",
            title: AppStrings.teachers,
            icon: Icons.person,
          ),
          DrawerItem(
            onTap: () {
              Navigator.of(context).pushNamed(   '/homeWorkPage');
            },
            imageUrl: "assets/svg/homework.svg",
            title: AppStrings.homeWork,
            icon: Icons.home_work,
          ),
          DrawerItem(
            onTap: () {
              Navigator.of(context).pushNamed(   '/duesPage');
            },
            title: AppStrings.dues,
          ),
        ],
      ),
    );
  }
}
