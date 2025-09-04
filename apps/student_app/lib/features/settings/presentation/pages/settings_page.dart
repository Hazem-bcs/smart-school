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
import '../widgets/support_section.dart';
import '../widgets/logout_dialog.dart';

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
