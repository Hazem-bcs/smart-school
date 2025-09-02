import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_school/routing/app_routes.dart';
import 'package:smart_school/widgets/app_exports.dart';
import 'package:smart_school/routing/navigation_extension.dart';

class AppDrawerWidget extends StatefulWidget {
  const AppDrawerWidget({super.key});

  @override
  State<AppDrawerWidget> createState() => _AppDrawerWidgetState();
}

class _AppDrawerWidgetState extends State<AppDrawerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateTo(BuildContext context, String routeName) {
    Navigator.of(context).pop();
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute != routeName) {
      switch (routeName) {
        case AppRoutes.profile:
          context.goToProfile();
          break;
        case AppRoutes.homework:
          context.goToHomework();
          break;
        case AppRoutes.subjects:
          context.goToSubjects();
          break;
        case AppRoutes.teachers:
          context.goToTeachers();
          break;
        case AppRoutes.attendance:
          context.goToAttendance();
          break;
        case AppRoutes.dues:
          context.goToDues();
          break;
        case AppRoutes.resources:
          context.goToResources();
          break;
        case AppRoutes.notifications:
          context.goToNotifications();
          break;
        case AppRoutes.zoom:
          context.goToZoom();
          break;
        case AppRoutes.settingsPage:
          context.goToSettings();
          break;
        default:
          Navigator.of(context).pushNamed(routeName);
      }
    }
  }

  Widget _buildAnimatedItem(int index, Widget child) {
    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          (0.05 * index).clamp(0.0, 1.0),
          (0.6 + 0.05 * index).clamp(0.0, 1.0),
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-0.2, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
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
          _buildAnimatedItem(0, _SectionHeader(title: "Academics")),
          _buildAnimatedItem(
              1,
              _DrawerItem(
                  title: AppStrings.homeWork,
                  assetPath: "assets/svg/homework.svg",
                  onTap: () => _navigateTo(context, '/homeWorkPage'))),
          _buildAnimatedItem(
              2,
              _DrawerItem(
                  title: AppStrings.subject,
                  assetPath: "assets/svg/homework.svg",
                  onTap: () => _navigateTo(context, '/subjectsPage'))),
          _buildAnimatedItem(
              3,
              _DrawerItem(
                  title: AppStrings.teachers,
                  assetPath: "assets/svg/profile.svg",
                  onTap: () => _navigateTo(context, '/teacherPage'))),
          const SizedBox(height: 10),
          _buildAnimatedItem(4, _SectionHeader(title: "School Life")),
          _buildAnimatedItem(
              5,
              _DrawerItem(
                  title: AppStrings.attendance,
                  assetPath: "assets/svg/attendance.svg",
                  onTap: () => _navigateTo(context, '/attendancePage'))),
          _buildAnimatedItem(
              6,
              _DrawerItem(
                  title: AppStrings.dues,
                  assetPath: "assets/svg/fee.svg",
                  onTap: () => _navigateTo(context, '/duesPage'))),
          _buildAnimatedItem(
              7,
              _DrawerItem(
                  title: AppStrings.resources,
                  assetPath: "assets/svg/media.svg",
                  onTap: () => _navigateTo(context, '/resourcesPage'))),
          _buildAnimatedItem(
              8,
              _DrawerItem(
                  title: AppStrings.notification,
                  assetPath: "assets/svg/notices.svg",
                  onTap: () => _navigateTo(context, '/notificationPage'))),
          _buildAnimatedItem(
              9,
              _DrawerItem(
                  title: "Zoom Meetings",
                  iconData: Icons.video_call,
                  onTap: () => _navigateTo(context, '/zoom'))),
          const SizedBox(height: 20),
          _buildAnimatedItem(
              10,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(color: Colors.grey.shade200),
              )),
          const SizedBox(height: 10),
          _buildAnimatedItem(
              11,
              _DrawerItem(
                  title: "Settings",
                  iconData: Icons.settings_outlined,
                  onTap: () => _navigateTo(context, '/settings'))),
        ],
      ),
    );
  }
}

// The helper widgets below remain stateless and unchanged, promoting clean code.

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
            AppAvatarWidget(
                imageUrl: imageUrl,
                radius: 32,
                isBordered: true,
                borderColor: Colors.white,
                borderThickness: 2),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    level,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
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
      padding: const EdgeInsets.only(
          left: 24.0, right: 24.0, top: 16.0, bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey.shade500,
          fontWeight: FontWeight.w600,
          fontSize: 12,
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
    final Color color =
        isDestructive ? Colors.red.shade700 : theme.textTheme.bodyLarge!.color!;
    final Color iconColor =
        isDestructive ? Colors.red.shade700 : theme.primaryColor;
    final Color iconBgColor = isDestructive
        ? Colors.red.withOpacity(0.1)
        : theme.primaryColor.withOpacity(0.1);

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
            fontSize: 16,
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
