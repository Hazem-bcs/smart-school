import 'package:flutter/material.dart';
import 'package:core/theme/constants/app_colors.dart';

import '../../../../widgets/responsive/responsive_widgets.dart';


class NewAssignmentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ThemeData theme;
  final bool isDark;
  final VoidCallback onClose;
  const NewAssignmentAppBar({Key? key, required this.theme, required this.isDark, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: isDark 
          ? AppColors.darkGradientStart
          : theme.appBarTheme.backgroundColor,
      elevation: 0,
      flexibleSpace: isDark ? Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.darkGradientStart,
              AppColors.darkGradientEnd,
            ],
          ),
        ),
      ) : null,
      leading: IconButton(
        icon: Icon(
          Icons.close, 
          color: isDark ? AppColors.darkAccentBlue : theme.iconTheme.color,
          size: 24,
        ),
        onPressed: onClose,
      ),
      title: ResponsiveText(
        'New Assignment',
        mobileSize: 18,
        tabletSize: 20,
        desktopSize: 22,
        style: TextStyle(
          color: isDark ? AppColors.darkAccentBlue : theme.textTheme.headlineSmall?.color,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 