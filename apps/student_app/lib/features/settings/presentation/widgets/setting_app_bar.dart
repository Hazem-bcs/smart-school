
import 'package:smart_school/widgets/app_exports.dart';

class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SettingsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      title: Text(
        'Settings',
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      automaticallyImplyLeading: false,
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 0,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
