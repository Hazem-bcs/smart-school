
import 'package:smart_school/widgets/app_exports.dart';

class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SettingsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Use a background color that adapts to theme, fallback if not set in appBarTheme
    final backgroundColor = theme.appBarTheme.backgroundColor ??
        (isDark ? theme.colorScheme.surface : theme.colorScheme.primary);

    // Use a foreground color that adapts to theme, fallback if not set in appBarTheme
    final foregroundColor = theme.appBarTheme.foregroundColor ??
        (isDark ? theme.colorScheme.onSurface : theme.colorScheme.onPrimary);

    return AppBar(
      title: Text(
        'الإعدادات',
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: foregroundColor,
        ),
      ),
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: theme.appBarTheme.iconTheme ??
          IconThemeData(color: foregroundColor),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
