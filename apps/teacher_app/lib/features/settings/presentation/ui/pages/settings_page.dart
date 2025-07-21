import 'package:core/theme/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:teacher_app/core/responsive/responsive_helper.dart';
import 'package:teacher_app/core/responsive/responsive_widgets.dart';
import 'package:teacher_app/core/widgets/shared_bottom_navigation.dart';
import '../../blocs/settings_bloc.dart';
import '../../blocs/settings_event.dart';
import '../../blocs/settings_state.dart';
import '../widgets/settings_app_bar.dart';
import '../widgets/settings_loading_state.dart';
import '../widgets/settings_error_state.dart';
import '../../widgets/profile_card.dart';
import '../../widgets/settings_section.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin {
  bool _notificationsEnabled = true;
  bool _isEnglish = true;
  String? _userId;

  late AnimationController _pageAnimationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadUserId();
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

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('user_id');
    });
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
      appBar: const SettingsAppBar(),
      body: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            _showSuccessMessage(context, state.logoutResult.message ?? 'تم تسجيل الخروج بنجاح');
            // Navigate to login after successful logout
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            });
          } else if (state is LogoutFailure) {
            _showErrorMessage(context, state.message);
          }
        },
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is LogoutLoading) {
              return const SettingsLoadingState();
            } else if (state is LogoutFailure) {
              return SettingsErrorState(
                message: state.message,
                onRetry: () => _performLogout(),
              );
            }

            return FadeTransition(
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
                            // Navigate to edit profile
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
                            // Toggle theme
                          },
                        ),
                        _buildSupportSection(theme, isDark),
                        SizedBox(
                          height: ResponsiveHelper.getSpacing(
                            context,
                            mobile: 80,
                            tablet: 100,
                            desktop: 120,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const SharedBottomNavigation(
        currentIndex: 3, // Settings index
      ),
    );
  }

  Widget _buildSupportSection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('الدعم والمساعدة', theme),
        _buildSettingsCard(
          [
            _buildAnimatedSettingTile(
              icon: Icons.help_outline,
              title: 'المساعدة والأسئلة الشائعة',
              subtitle: 'احصل على المساعدة واعثر على الإجابات',
              trailing: Container(
                padding: EdgeInsets.all(
                  ResponsiveHelper.getSpacing(
                    context,
                    mobile: 8,
                    tablet: 10,
                    desktop: 12,
                  ),
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardBackground : AppColors.gray100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: theme.iconTheme.color,
                  size: ResponsiveHelper.getIconSize(
                    context,
                    mobile: 14,
                    tablet: 16,
                    desktop: 18,
                  ),
                ),
              ),
              onTap: () => Navigator.pushNamed(context, '/help-faq'),
              theme: theme,
              isDark: isDark,
            ),
            _buildAnimatedSettingTile(
              icon: Icons.info_outline,
              title: 'حول التطبيق',
              subtitle: 'الإصدار 1.0.0',
              trailing: Container(
                padding: EdgeInsets.all(
                  ResponsiveHelper.getSpacing(
                    context,
                    mobile: 8,
                    tablet: 10,
                    desktop: 12,
                  ),
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardBackground : AppColors.gray100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: theme.iconTheme.color,
                  size: ResponsiveHelper.getIconSize(
                    context,
                    mobile: 14,
                    tablet: 16,
                    desktop: 18,
                  ),
                ),
              ),
              onTap: () => Navigator.pushNamed(context, '/about-app'),
              theme: theme,
              isDark: isDark,
            ),
            _buildAnimatedSettingTile(
              icon: Icons.logout,
              title: 'تسجيل الخروج',
              subtitle: 'تسجيل الخروج من حسابك',
              trailing: Container(
                padding: EdgeInsets.all(
                  ResponsiveHelper.getSpacing(
                    context,
                    mobile: 8,
                    tablet: 10,
                    desktop: 12,
                  ),
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkDestructive.withOpacity(0.2)
                      : AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: isDark ? AppColors.darkDestructive : AppColors.error,
                  size: ResponsiveHelper.getIconSize(
                    context,
                    mobile: 14,
                    tablet: 16,
                    desktop: 18,
                  ),
                ),
              ),
              onTap: _showLogoutDialog,
              isDestructive: true,
              theme: theme,
              isDark: isDark,
            ),
          ],
          theme,
          isDark,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
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
          mobile: 16,
          tablet: 20,
          desktop: 24,
        ),
      ),
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    List<Widget> children,
    ThemeData theme,
    bool isDark,
  ) {
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
              leading: Container(
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

  void _showLogoutDialog() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.darkCardBackground
            : theme.dialogTheme.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkDestructive.withOpacity(0.2)
                    : AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.logout,
                color: isDark ? AppColors.darkDestructive : AppColors.error,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'تسجيل الخروج',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? AppColors.darkDestructive : AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'تسجيل الخروج',
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

  void _performLogout() {
    if (_userId != null) {
      context.read<SettingsBloc>().add(LogoutRequested(userId: _userId!));
    } else {
      _showErrorMessage(context, 'لم يتم العثور على معرف المستخدم');
    }
  }

  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'إعادة المحاولة',
          textColor: Colors.white,
          onPressed: _performLogout,
        ),
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
} 