import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_school/features/authentication/presentation/blocs/auth_bloc.dart';
import 'package:smart_school/widgets/app_exports.dart';

// To keep things simple and avoid file sync issues,
// the helper widgets are defined within the same file.

class AppDrawerWidget extends StatelessWidget {
  const AppDrawerWidget({super.key});

  void _navigateTo(BuildContext context, String routeName) {
    Navigator.of(context).pop(); // Close the drawer first
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute != routeName) {
      Navigator.of(context).pushNamed(routeName);
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text('Logout', style: TextStyle(color: Colors.red.shade700)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<AuthBloc>().add(LogoutEvent());
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _DrawerHeader(
            name: "Student Name",
            level: "Class 10 - A",
            imageUrl: "assets/images/user_3.png",
            onTap: () => _navigateTo(context, '/profilePage'),
          ),
          const SizedBox(height: 10),
          _SectionHeader(title: "Academics"),
          _DrawerItem(
            title: AppStrings.homeWork,
            assetPath: "assets/svg/homework.svg",
            onTap: () => _navigateTo(context, '/homeWorkPage'),
          ),
          _DrawerItem(
            title: AppStrings.subject,
            assetPath: "assets/svg/book.svg", // Using a more appropriate icon
            onTap: () => _navigateTo(context, '/subjectsPage'),
          ),
          _DrawerItem(
            title: AppStrings.teachers,
            assetPath: "assets/svg/profile.svg",
            onTap: () => _navigateTo(context, '/teacherPage'),
          ),
          const SizedBox(height: 10),
          _SectionHeader(title: "School Life"),
          _DrawerItem(
            title: AppStrings.attendance,
            assetPath: "assets/svg/attendance.svg",
            onTap: () => _navigateTo(context, '/attendancePage'),
          ),
          _DrawerItem(
            title: AppStrings.dues,
            assetPath: "assets/svg/fee.svg",
            onTap: () => _navigateTo(context, '/duesPage'),
          ),
          _DrawerItem(
            title: AppStrings.resources,
            assetPath: "assets/svg/media.svg",
            onTap: () => _navigateTo(context, '/resourcesPage'),
          ),
          _DrawerItem(
            title: AppStrings.notification,
            assetPath: "assets/svg/notices.svg",
            onTap: () => _navigateTo(context, '/notificationPage'),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(color: Colors.grey.shade200),
          ),
          const SizedBox(height: 10),
          _DrawerItem(
            title: "Settings",
            iconData: Icons.settings_outlined,
            onTap: () => _navigateTo(context, '/settings'),
          ),
          _DrawerItem(
            title: "Logout",
            iconData: Icons.logout,
            isDestructive: true,
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  final String name;
  final String level;
  final String imageUrl;
  final VoidCallback onTap;

  const _DrawerHeader({
    required this.name,
    required this.level,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF7B61FF),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 24,
        left: 24,
        right: 24,
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            AppAvatarWidget(imageUrl: imageUrl, radius: 32, isBordered: true, borderColor: Colors.white, borderThickness: 2),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18, // Appropriate font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    level,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14, // Appropriate font size
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

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0, bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey.shade500,
          fontWeight: FontWeight.w600,
          fontSize: 12, // Small, subtle font size
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String title;
  final String? assetPath;
  final IconData? iconData;
  final VoidCallback onTap;
  final bool isDestructive;

  const _DrawerItem({
    required this.title,
    required this.onTap,
    this.assetPath,
    this.iconData,
    this.isDestructive = false,
  }) : assert(assetPath != null || iconData != null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color color = isDestructive ? Colors.red.shade700 : theme.textTheme.bodyLarge!.color!;
    final Color iconColor = isDestructive ? Colors.red.shade700 : theme.primaryColor;
    final Color iconBgColor = isDestructive ? Colors.red.withOpacity(0.1) : theme.primaryColor.withOpacity(0.1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: assetPath != null
              ? SvgPicture.asset(
                  assetPath!,
                )
              : Icon(iconData, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16, // Appropriate font size
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        horizontalTitleGap: 16,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }
}


