import 'package:flutter/material.dart';
import '../../../../../core/responsive/responsive_widgets.dart';

class AssignmentsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onAdd;

  const AssignmentsAppBar({
    Key? key,
    required this.title,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 0,
      title: ResponsiveText(
        title,
        mobileSize: 18,
        tabletSize: 20,
        desktopSize: 22,
        style: theme.textTheme.headlineSmall?.copyWith(
          color: theme.appBarTheme.foregroundColor ?? (isDark ? Colors.white : const Color(0xFF0E141B)),
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.add, color: theme.iconTheme.color ?? (isDark ? Colors.white : const Color(0xFF0E141B))),
          onPressed: onAdd,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 