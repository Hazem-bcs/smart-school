import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/theme/index.dart';
import 'package:teacher_app/features/assignment/presentation/ui/pages/assignments_page.dart';
import 'package:teacher_app/features/schedule/presentation/ui/pages/schedule_page.dart';
import '../../../../blocs/theme/theme_bloc.dart';
import '../../../../core/responsive_helper.dart';
import '../../../../core/responsive_widgets.dart';
import '../../../../../widgets/shared_bottom_navigation.dart';
import '../../../../../routing/navigation_extension.dart';
import '../widgets/profile_card.dart';
import '../widgets/settings_section.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  bool _notificationsEnabled = true;
  bool _isEnglish = true;
  
  late AnimationController _pageAnimationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _pageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pageAnimationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _pageAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.elasticOut,
    ));

    _pageAnimationController.forward();
    _cardAnimationController.forward();
  }

  @override
  void dispose() {
    _pageAnimationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ResponsiveContent(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  ProfileCard(
                    theme: theme,
                    isDark: isDark,
                    scaleAnimation: _scaleAnimation,
                    onEditProfile: () {
                      context.goToEditProfile();
                    },
                  ),
                  SettingsSection(
                    theme: theme,
                    isDark: isDark,
                    notificationsEnabled: _notificationsEnabled,
                    onNotificationsChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                    isEnglish: _isEnglish,
                    onLanguageToggle: _toggleLanguage,
                    onThemeToggle: () {
                      context.read<ThemeBloc>().add(ToggleTheme());
                    },
                  ),
                  _buildSupportSection(theme, isDark),
                  SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 80, tablet: 100, desktop: 120)),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SharedBottomNavigation(
        currentIndex: 3, // Settings index
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
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

  Widget _buildSupportSection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Support & About', theme),
        _buildSettingsCard([
          _buildAnimatedSettingTile(
            icon: Icons.help_outline,
            title: 'Help & FAQ',
            subtitle: 'Get help and find answers',
            trailing: Container(
              padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 10, desktop: 12)),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBackground : AppColors.gray100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: theme.iconTheme.color,
                size: ResponsiveHelper.getIconSize(context, mobile: 14, tablet: 16, desktop: 18),
              ),
            ),
            onTap: () => Navigator.pushNamed(context, '/help-faq'),
            theme: theme,
            isDark: isDark,
          ),
          _buildAnimatedSettingTile(
            icon: Icons.info_outline,
            title: 'About App',
            subtitle: 'Version 1.0.0',
            trailing: Container(
              padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 10, desktop: 12)),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBackground : AppColors.gray100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: theme.iconTheme.color,
                size: ResponsiveHelper.getIconSize(context, mobile: 14, tablet: 16, desktop: 18),
              ),
            ),
            onTap: () => Navigator.pushNamed(context, '/about-app'),
            theme: theme,
            isDark: isDark,
          ),
          _buildAnimatedSettingTile(
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Sign out of your account',
            trailing: Container(
              padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 10, desktop: 12)),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkDestructive.withOpacity(0.2) : AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: isDark ? AppColors.darkDestructive : AppColors.error,
                size: ResponsiveHelper.getIconSize(context, mobile: 14, tablet: 16, desktop: 18),
              ),
            ),
            onTap: _showLogoutDialog,
            isDestructive: true,
            theme: theme,
            isDark: isDark,
          ),
        ], theme, isDark),
      ],
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28),
        vertical: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24),
      ),
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children, ThemeData theme, bool isDark) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.getSpacing(context)),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildAnimatedSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool isDestructive = false,
    required ThemeData theme,
    required bool isDark,
  }) {
    return AnimatedBuilder(
      animation: _cardAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * _cardAnimationController.value),
          child: Container(
            margin: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 4, tablet: 6, desktop: 8)),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBackground : theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.dividerColor.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: ListTile(
              leading: Container(
                padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 10, desktop: 12)),
                decoration: BoxDecoration(
                  color: isDestructive 
                      ? (isDark ? AppColors.darkDestructive.withOpacity(0.2) : AppColors.error.withOpacity(0.1))
                      : (isDark ? AppColors.darkAccentBlue.withOpacity(0.2) : AppColors.info.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isDestructive 
                      ? (isDark ? AppColors.darkDestructive : AppColors.error)
                      : (isDark ? AppColors.darkAccentBlue : AppColors.info),
                  size: ResponsiveHelper.getIconSize(context, mobile: 20, tablet: 22, desktop: 24),
                ),
              ),
              title: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDestructive 
                      ? (isDark ? AppColors.darkDestructive : AppColors.error)
                      : theme.textTheme.titleMedium?.color,
                ),
              ),
              subtitle: Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
              trailing: trailing,
              onTap: onTap,
              contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24),
                vertical: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeToggleTile(ThemeData theme, bool isDark) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        bool isDarkMode = false;
        
        if (state is ThemeLoaded) {
          isDarkMode = state.isDarkMode;
        } else {
          isDarkMode = context.isDarkMode;
        }

        return _buildAnimatedSettingTile(
          icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
          title: 'Dark Mode',
          subtitle: isDarkMode ? 'Enabled' : 'Disabled',
          trailing: _buildAnimatedSwitch(isDarkMode, (value) {
            context.read<ThemeBloc>().add(ToggleTheme());
          }, theme, isDark),
          theme: theme,
          isDark: isDark,
        );
      },
    );
  }

  Widget _buildAnimatedSwitch(bool value, ValueChanged<bool> onChanged, ThemeData theme, bool isDark) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: ResponsiveHelper.getIconSize(context, mobile: 50, tablet: 55, desktop: 60),
        height: ResponsiveHelper.getIconSize(context, mobile: 28, tablet: 30, desktop: 32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: value 
              ? (isDark ? AppColors.darkSuccess : AppColors.success)
              : (isDark ? AppColors.darkDivider : AppColors.gray300),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: value ? ResponsiveHelper.getIconSize(context, mobile: 22, tablet: 25, desktop: 28) : 2,
              top: 2,
              child: Container(
                width: ResponsiveHelper.getIconSize(context, mobile: 24, tablet: 26, desktop: 28),
                height: ResponsiveHelper.getIconSize(context, mobile: 24, tablet: 26, desktop: 28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCardBackground : theme.dialogTheme.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkDestructive.withOpacity(0.2) : AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.logout,
                color: isDark ? AppColors.darkDestructive : AppColors.error,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Logout',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? AppColors.darkDestructive : AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Logout',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleLanguage() {
    setState(() {
      _isEnglish = !_isEnglish;
    });
    
    if (_isEnglish) {
      context.setLocale(const Locale('en'));
    } else {
      context.setLocale(const Locale('ar'));
    }
  }

  void _onNavItemTap(int index) {
    switch (index) {
      case 0: // Dashboard
        context.goToHome(className: 'Default Class');
        break;
      case 1: // Assignments
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const AssignmentsPage(),
          ),
        );
        break;
      case 2: // Schedule
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const SchedulePage(),
          ),
        );
        break;
      case 3: // Settings
        // Already on Settings page
        break;
    }
  }
} 