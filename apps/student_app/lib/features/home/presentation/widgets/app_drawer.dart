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
          _BuildCurrentUserRow(
            name: "username",
            level: "level",
            onTap: () {
              Navigator.of(context).pushNamed('/profilePage');
            },
          ),
          SizedBox(height: 40),
          DrawerItem(
            onTap: () {
              Navigator.of(context).pushNamed('/teacherPage');
            },
            imageUrl: "assets/svg/profile.svg",
            title: AppStrings.teachers,
            icon: Icons.person,
          ),
          DrawerItem(
            onTap: () {
              Navigator.of(context).pushNamed('/homeWorkPage');
            },
            imageUrl: "assets/svg/homework.svg",
            title: AppStrings.homeWork,
            icon: Icons.home_work,
          ),
          DrawerItem(
            onTap: () {
              Navigator.of(context).pushNamed('/duesPage');
            },
            title: AppStrings.dues,
          ), DrawerItem(
            onTap: () {
              Navigator.of(context).pushNamed('/subjectsPage');
            },
            title: AppStrings.subject,
          ), DrawerItem(
            onTap: () {
              Navigator.of(context).pushNamed(  '/attendancePage');
            },
            title: AppStrings.attendance,
            imageUrl:"assets/svg/attendance.svg",
          ), DrawerItem(
            onTap: () {
              Navigator.of(context).pushNamed(   '/resourcesPage');
            },
            title: AppStrings.resources,
            imageUrl: "assets/svg/media.svg",
          ), DrawerItem(
            onTap: () {
              Navigator.of(context).pushNamed(    '/notificationPage');
            },
            title: AppStrings.notification,
            imageUrl: "assets/svg/notices.svg",
          ),
        ],
      ),
    );
  }
}

class _BuildCurrentUserRow extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final String level;
  final void Function()? onTap;

  const _BuildCurrentUserRow({
    super.key,
    this.imageUrl,
    required this.name,
    required this.level,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 20),
          AppAvatarWidget(imageUrl: imageUrl ?? "assets/images/img.png"),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextWidget(text: "user name"),
              AppTextWidget(text: "level"),
            ],
          ),
        ],
      ),
    );
  }
}
