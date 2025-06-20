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
              Navigator.of(context).pushNamed('/teachersPage');
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
        children: [
          SizedBox(width: 20),
          AppAvatarWidget(imageUrl: imageUrl ?? "assets/images/img.png"),
          SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
