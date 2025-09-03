import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/theme/index.dart';
import 'package:core/widgets/index.dart';
import 'package:core/blocs/theme/theme_bloc.dart';
import 'package:core/blocs/theme/theme_event.dart';
import 'package:smart_school/widgets/app_bar_widget.dart';

import '../../../../widgets/responsive/responsive_helper.dart';
import '../../../../widgets/responsive/responsive_widgets.dart';
import '../../../../widgets/shared_bottom_navigation.dart';
import '../../../../widgets/modern_design/modern_effects.dart';
import '../../../authentication/presentation/blocs/auth_bloc.dart';
import '../blocs/settings_bloc.dart';
import '../blocs/settings_event.dart';
import '../blocs/settings_state.dart';
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

  // Controllers for name, email, and image
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    // اطلب بيانات المستخدم عند فتح الصفحة
    context.read<SettingsBloc>().add(const GetProfileEvent());
    _nameController = TextEditingController();
    _emailController = TextEditingController();
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

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pageAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _pageAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _cardAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _pageAnimationController.forward();
    _cardAnimationController.forward();
  }

  @override
  void dispose() {
    _pageAnimationController.dispose();
    _cardAnimationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
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

  void _showLogoutDialog() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => LogoutDialog(
        theme: theme,
        isDark: isDark,
        onConfirm: () {
          Navigator.pop(context);
          context.read<AuthBloc>().add(LogoutEvent());
        },
      ),
    );
  }

  void _authListener(BuildContext context, AuthState state) {
    if (state is LogoutSuccess) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    } else if (state is LogoutFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: _authListener,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: const AppBarWidget(
          title: 'الإعدادات',
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is GetProfileLoading) {
              return const SmartSchoolLoading(
                message: 'جاري تحميل الملف الشخصي...',
                type: LoadingType.primary,
              );
            } else if (state is GetProfileFailure) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state is GetProfileSuccess) {
              // Fill the controllers with the values from the bloc
              _nameController.text = state.user.name ?? '';
              _emailController.text = state.user.email;

              return SettingsBody(
                fadeAnimation: _fadeAnimation,
                slideAnimation: _slideAnimation,
                scaleAnimation: _scaleAnimation,
                cardAnimationController: _cardAnimationController,
                notificationsEnabled: _notificationsEnabled,
                isEnglish: _isEnglish,
                user: state.user,
                nameController: _nameController,
                emailController: _emailController,
                onNotificationsChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
                onLanguageToggle: _toggleLanguage,
                onThemeToggle: () {
                  context.read<ThemeBloc>().add(ToggleTheme());
                },
                onEditProfile: () {
                  Navigator.pushNamed(context, '/profilePage');
                },
                onShowLogoutDialog: _showLogoutDialog,
              );
            }
            // الحالة الافتراضية (مثلاً عند أول تحميل)
            return const SmartSchoolLoading(
              message: 'جاري التحميل...',
              type: LoadingType.primary,
            );
          },
        ),
        bottomNavigationBar: const SettingsBottomNavigationBar(),
      ),
    );
  }
}

// ----------------- Widgets Refactored -----------------

class SettingsBody extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final Animation<double> scaleAnimation;
  final AnimationController cardAnimationController;
  final bool notificationsEnabled;
  final bool isEnglish;
  final ValueChanged<bool> onNotificationsChanged;
  final VoidCallback onLanguageToggle;
  final VoidCallback onThemeToggle;
  final VoidCallback onEditProfile;
  final VoidCallback onShowLogoutDialog;
  final user; // UserEntity

  // Add controllers for name, email, and image
  final TextEditingController nameController;
  final TextEditingController emailController;

  const SettingsBody({
    super.key,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.scaleAnimation,
    required this.cardAnimationController,
    required this.notificationsEnabled,
    required this.isEnglish,
    required this.onNotificationsChanged,
    required this.onLanguageToggle,
    required this.onThemeToggle,
    required this.onEditProfile,
    required this.onShowLogoutDialog,
    required this.user,
    required this.nameController,
    required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: ResponsiveContent(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                ProfileCard(
                  theme: theme,
                  isDark: isDark,
                  scaleAnimation: scaleAnimation,
                  onEditProfile: onEditProfile,
                  name: nameController.text,
                  email: emailController.text,
                ),
                SettingsSection(
                  theme: theme,
                  isDark: isDark,
                  notificationsEnabled: notificationsEnabled,
                  onNotificationsChanged: onNotificationsChanged,
                  isEnglish: isEnglish,
                  onLanguageToggle: onLanguageToggle,
                  onThemeToggle: onThemeToggle,
                ),
                SupportSection(
                  cardAnimationController: cardAnimationController,
                  scaleAnimation: scaleAnimation,
                  onShowLogoutDialog: onShowLogoutDialog,
                ),
                const BottomSpacing(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SupportSection extends StatelessWidget {
  final AnimationController cardAnimationController;
  final Animation<double> scaleAnimation;
  final VoidCallback onShowLogoutDialog;

  const SupportSection({
    super.key,
    required this.cardAnimationController,
    required this.scaleAnimation,
    required this.onShowLogoutDialog,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Support & About'),
        _buildModernSupportCard(context, theme, isDark),
      ],
    );
  }

  Widget _buildModernSupportCard(BuildContext context, ThemeData theme, bool isDark) {
    return ModernEffects.neumorphism(
      isDark: isDark,
      distance: 6.0,
      intensity: 0.1,
      borderRadius: BorderRadius.circular(20),
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.getSpacing(context)),
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16)),
      child: Column(
        children: [
          _buildModernSupportTile(
            context: context,
            theme: theme,
            isDark: isDark,
            icon: Icons.help_outline_rounded,
            iconColor: isDark ? AppColors.darkAccentBlue : AppColors.info,
            title: 'Help & FAQ',
            subtitle: 'Get help and find answers',
            onTap: () => Navigator.pushNamed(context, '/help-faq'),
          ),
          _buildDivider(isDark),
          _buildModernSupportTile(
            context: context,
            theme: theme,
            isDark: isDark,
            icon: Icons.info_outline_rounded,
            iconColor: isDark ? AppColors.darkSuccess : AppColors.success,
            title: 'About App',
            subtitle: 'Version 1.0.0',
            onTap: () => Navigator.pushNamed(context, '/about-app'),
          ),
          _buildDivider(isDark),
          _buildModernSupportTile(
            context: context,
            theme: theme,
            isDark: isDark,
            icon: Icons.logout_rounded,
            iconColor: isDark ? AppColors.darkDestructive : AppColors.error,
            title: 'Logout',
            subtitle: 'Sign out of your account',
            onTap: onShowLogoutDialog,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildModernSupportTile({
    required BuildContext context,
    required ThemeData theme,
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24)),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 14, desktop: 16)),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: iconColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: ResponsiveHelper.getIconSize(context, mobile: 22, tablet: 24, desktop: 26),
              ),
            ),
            SizedBox(width: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                      color: isDestructive 
                        ? iconColor 
                        : (isDark ? AppColors.darkPrimaryText : AppColors.gray800),
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 4, tablet: 6, desktop: 8)),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                      color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkElevatedSurface : AppColors.gray100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: isDark ? AppColors.darkSecondaryText : AppColors.gray500,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            isDark ? AppColors.darkDivider.withOpacity(0.3) : AppColors.gray200.withOpacity(0.5),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(
          context,
          mobile: 20,
          tablet: 24,
          desktop: 28,
        ),
        vertical: ResponsiveHelper.getSpacing(
          context,
          mobile: 20,
          tablet: 24,
          desktop: 28,
        ),
      ),
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: ResponsiveHelper.getFontSize(context, mobile: 22, tablet: 24, desktop: 26),
          letterSpacing: 0.5,
          color: isDark ? AppColors.darkPrimaryText : AppColors.gray800,
        ),
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const SettingsCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(context),
      ),
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
}

class AnimatedSettingTile extends StatelessWidget {
  final AnimationController cardAnimationController;
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDestructive;

  const AnimatedSettingTile({
    super.key,
    required this.cardAnimationController,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: cardAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * cardAnimationController.value),
          child: Container(
            margin: EdgeInsets.all(
              ResponsiveHelper.getSpacing(
                context,
                mobile: 4,
                tablet: 6,
                desktop: 8,
              ),
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBackground : theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.dividerColor.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: ListTile(
              leading: TileLeading(
                icon: icon,
                isDestructive: isDestructive,
              ),
              title: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDestructive
                      ? (isDark
                          ? AppColors.darkDestructive
                          : AppColors.error)
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
                horizontal: ResponsiveHelper.getSpacing(
                  context,
                  mobile: 16,
                  tablet: 20,
                  desktop: 24,
                ),
                vertical: ResponsiveHelper.getSpacing(
                  context,
                  mobile: 8,
                  tablet: 12,
                  desktop: 16,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class TileLeading extends StatelessWidget {
  final IconData icon;
  final bool isDestructive;
  const TileLeading({
    super.key,
    required this.icon,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(
        ResponsiveHelper.getSpacing(
          context,
          mobile: 8,
          tablet: 10,
          desktop: 12,
        ),
      ),
      decoration: BoxDecoration(
        color: isDestructive
            ? (isDark
                ? AppColors.darkDestructive.withOpacity(0.2)
                : AppColors.error.withOpacity(0.1))
            : (isDark
                ? AppColors.darkAccentBlue.withOpacity(0.2)
                : AppColors.info.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        color: isDestructive
            ? (isDark ? AppColors.darkDestructive : AppColors.error)
            : (isDark ? AppColors.darkAccentBlue : AppColors.info),
        size: ResponsiveHelper.getIconSize(
          context,
          mobile: 20,
          tablet: 22,
          desktop: 24,
        ),
      ),
    );
  }
}

class TrailingIcon extends StatelessWidget {
  final bool isDestructive;
  const TrailingIcon({super.key, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(
        ResponsiveHelper.getSpacing(
          context,
          mobile: 8,
          tablet: 10,
          desktop: 12,
        ),
      ),
      decoration: BoxDecoration(
        color: isDestructive
            ? (isDark
                ? AppColors.darkDestructive.withOpacity(0.2)
                : AppColors.error.withOpacity(0.1))
            : (isDark
                ? AppColors.darkCardBackground
                : AppColors.gray100),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.arrow_forward_ios,
        color: isDestructive
            ? (isDark ? AppColors.darkDestructive : AppColors.error)
            : theme.iconTheme.color,
        size: ResponsiveHelper.getIconSize(
          context,
          mobile: 14,
          tablet: 16,
          desktop: 18,
        ),
      ),
    );
  }
}

class BottomSpacing extends StatelessWidget {
  const BottomSpacing({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveHelper.getSpacing(
        context,
        mobile: 80,
        tablet: 100,
        desktop: 120,
      ),
    );
  }
}

class SettingsBottomNavigationBar extends StatelessWidget {
  const SettingsBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedBottomNavigation(
      currentIndex: 3,
      onTap: (int index) {},
    );
  }
}

class LogoutDialog extends StatelessWidget {
  final ThemeData theme;
  final bool isDark;
  final VoidCallback onConfirm;

  const LogoutDialog({
    super.key,
    required this.theme,
    required this.isDark,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ModernEffects.glassmorphism(
        isDark: isDark,
        opacity: 0.95,
        blur: 20.0,
        borderOpacity: 0.3,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 24, tablet: 28, desktop: 32)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogIcon(context),
              SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28)),
              _buildDialogTitle(context),
              SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20)),
              _buildDialogContent(context),
              SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 28, tablet: 32, desktop: 36)),
              _buildDialogActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogIcon(BuildContext context) {
    final iconColor = isDark ? AppColors.darkDestructive : AppColors.error;
    
    return Container(
      width: ResponsiveHelper.getIconSize(context, mobile: 70, tablet: 80, desktop: 90),
      height: ResponsiveHelper.getIconSize(context, mobile: 70, tablet: 80, desktop: 90),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            iconColor.withOpacity(0.2),
            iconColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: iconColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Icon(
        Icons.logout_rounded,
        color: iconColor,
        size: ResponsiveHelper.getIconSize(context, mobile: 35, tablet: 40, desktop: 45),
      ),
    );
  }

  Widget _buildDialogTitle(BuildContext context) {
    return Text(
      'Logout',
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: ResponsiveHelper.getFontSize(context, mobile: 22, tablet: 24, desktop: 26),
        color: isDark ? AppColors.darkPrimaryText : AppColors.gray800,
      ),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Text(
      'Are you sure you want to logout?',
      textAlign: TextAlign.center,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
        color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
        height: 1.5,
      ),
    );
  }

  Widget _buildDialogActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildCancelButton(context),
        ),
        SizedBox(width: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20)),
        Expanded(
          child: _buildLogoutButton(context),
        ),
      ],
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return Container(
      height: ResponsiveHelper.getButtonHeight(context),
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? AppColors.darkElevatedSurface : AppColors.gray100,
          foregroundColor: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          'Cancel',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final buttonColor = isDark ? AppColors.darkDestructive : AppColors.error;
    
    return Container(
      height: ResponsiveHelper.getButtonHeight(context),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            buttonColor,
            buttonColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: buttonColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onConfirm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          'Logout',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
