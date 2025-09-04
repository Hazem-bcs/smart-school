import 'package:core/theme/app_bar_theme.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool useGradient;
  final GradientType gradientType;
  final IconData? leadingIcon;
  final VoidCallback? onLeadingPressed;
  final bool automaticallyImplyLeading;

  const AppBarWidget({
    super.key, 
    required this.title, 
    this.actions,
    this.useGradient = true,
    this.gradientType = GradientType.primary,
    this.leadingIcon,
    this.onLeadingPressed,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasDrawer = Scaffold.maybeOf(context)?.hasDrawer ?? false;
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      toolbarHeight: 70,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: useGradient ? Colors.transparent : AppColors.primary,
      foregroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
      
      // Gradient background
      flexibleSpace: useGradient ? Container(
        decoration: SmartSchoolAppBarTheme.getGradientDecoration(
          isDark: isDark,
          type: gradientType,
        ),
      ) : null,
      
      // Title with unified styling
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          title,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      
      // Unified icon theme
      iconTheme: const IconThemeData(
        color: AppColors.white,
        size: 22,
      ),
      
      centerTitle: true,
      
      // Custom leading widget
      leading: _buildLeading(context, hasDrawer, canPop, isDark),
      
      // Actions with unified styling
      actions: actions,
      
      // Unified shape
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
    );
  }

  Widget? _buildLeading(BuildContext context, bool hasDrawer, bool canPop, bool isDark) {
    if (leadingIcon != null && onLeadingPressed != null) {
      return SmartSchoolAppBarTheme.createLeadingIcon(
        icon: leadingIcon!,
        onPressed: onLeadingPressed!,
        isDark: isDark,
      );
    }
    
    if (hasDrawer) {
      return Builder(
        builder: (context) => IconButton(
                  icon: Container(
          padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.menu,
              color: AppColors.white,
              size: 18,
            ),
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      );
    }
    
    if (canPop && automaticallyImplyLeading) {
      return IconButton(
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.white,
            size: 18,
            ),
        ),
        onPressed: () => Navigator.of(context).pop(),
      );
    }
    
    return null;
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

/// Helper class for creating unified AppBar actions
class AppBarActions {
  AppBarActions._();

  /// Creates a refresh action button
  static Widget refresh({
    required VoidCallback onPressed,
    required bool isDark,
  }) {
    return SmartSchoolAppBarTheme.createActionButton(
      icon: Icons.refresh_rounded,
      onPressed: onPressed,
      isDark: isDark,
      tooltip: 'تحديث',
    );
  }

  /// Creates a notification action button
  static Widget notification({
    required VoidCallback onPressed,
    required bool isDark,
    int? count,
  }) {
    return Stack(
      children: [
        SmartSchoolAppBarTheme.createActionButton(
          icon: Icons.notifications_outlined,
          onPressed: onPressed,
          isDark: isDark,
          tooltip: 'الإشعارات',
        ),
        if (count != null && count > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Creates a chat action button
  static Widget chat({
    required VoidCallback onPressed,
    required bool isDark,
  }) {
    return SmartSchoolAppBarTheme.createActionButton(
      icon: Icons.chat_outlined,
      onPressed: onPressed,
      isDark: isDark,
      tooltip: 'المحادثة',
    );
  }

  /// Creates a search action button
  static Widget search({
    required VoidCallback onPressed,
    required bool isDark,
  }) {
    return SmartSchoolAppBarTheme.createActionButton(
      icon: Icons.search,
      onPressed: onPressed,
      isDark: isDark,
      tooltip: 'البحث',
    );
  }

  /// Creates a counter badge (like assignment count)
  static Widget counter({
    required String text,
    required bool isDark,
    Color? backgroundColor,
  }) {
    return SmartSchoolAppBarTheme.createBadge(
      text: text,
      isDark: isDark,
      backgroundColor: backgroundColor,
    );
  }
}