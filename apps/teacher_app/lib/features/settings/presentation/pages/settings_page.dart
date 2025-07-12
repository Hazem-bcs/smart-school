import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/theme/index.dart';
import '../../../../blocs/theme/theme_bloc.dart';
import '../../../../core/responsive_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _isEnglish = true; // true for English, false for Arabic

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'settings.title'.tr(),
        style: Theme.of(context).textTheme.titleLarge?.responsive(context),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Theme.of(context).colorScheme.primary,
          size: ResponsiveHelper.getIconSize(context),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: ResponsiveHelper.getAppBarHeight(context),
    );
  }

  Widget _buildBody() {
    return BlocListener<ThemeBloc, ThemeState>(
      listener: (context, state) {
        if (state is ThemeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.getMaxContentWidth(context),
          ),
          child: ListView(
            padding: ResponsiveHelper.getScreenPadding(context),
            children: [
          _buildProfileCard(),
          _buildSectionHeader('settings.other_settings'.tr(), topPadding: 32, bottomPadding: 8),
          _buildSettingsGroup([
            _buildToggleItem(
              Icons.person,
              'settings.profile_details'.tr(),
              _isEnglish,
              (value) {
                setState(() {
                  _isEnglish = value;
                });
                _toggleLanguage();
              },
            ),
            _buildNavigationItem(
              Icons.lock,
              'settings.password'.tr(),
              () => Navigator.pushNamed(context, '/change-password'),
            ),
            _buildToggleItem(
              Icons.notifications,
              'settings.notifications'.tr(),
              _notificationsEnabled,
              (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            _buildThemeToggleItem(),
          ]),
          _buildSettingsGroup([
            _buildNavigationItem(
              Icons.info_outline,
              'settings.about_application'.tr(),
              () => Navigator.pushNamed(context, '/about-app'),
            ),
            _buildNavigationItem(
              Icons.help_outline,
              'settings.help_faq'.tr(),
              () => Navigator.pushNamed(context, '/help-faq'),
            ),
            _buildDestructiveItem(
              Icons.logout,
              'settings.logout'.tr(),
              () => _showLogoutDialog(),
            ),
          ], topMargin: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeToggleItem() {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        bool isDarkMode = false;
        
        if (state is ThemeLoaded) {
          isDarkMode = state.isDarkMode;
        } else {
          // Fallback to system theme detection
          isDarkMode = context.isDarkMode;
        }

        return _buildToggleItem(
          Icons.brightness_4,
          'settings.dark_mode'.tr(),
          isDarkMode,
          (value) {
            context.read<ThemeBloc>().add(ToggleTheme());
          },
        );
      },
    );
  }

  Widget _buildProfileCard() {
    return Card(
      margin: EdgeInsets.zero,
      elevation: ResponsiveHelper.getCardElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context)),
      ),
      child: InkWell(
        onTap: () => print('Profile tapped'),
        borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context)),
        child: Padding(
          padding: ResponsiveHelper.getScreenPadding(context),
          child: Row(
            children: [
              CircleAvatar(
                radius: ResponsiveHelper.isMobile(context) ? 30 : 40,
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  size: ResponsiveHelper.getIconSize(context),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'settings.profile_card.name'.tr(),
                      style: Theme.of(context).textTheme.titleMedium?.responsive(context),
                    ),
                    SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 4, tablet: 6, desktop: 8)),
                    Text(
                      'settings.profile_card.role'.tr(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ).responsive(context),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.secondary,
                size: ResponsiveHelper.getIconSize(context, mobile: 16, tablet: 20, desktop: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {double topPadding = 0, double bottomPadding = 0}) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: AppTextStyles.semiBold,
        ).responsive(context),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> items, {double topMargin = 0}) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context)),
        border: Border.all(
          color: Theme.of(context).dividerTheme.color!,
          width: 1,
        ),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;
          
          return Column(
            children: [
              item,
              if (!isLast)
                Divider(
                  color: Theme.of(context).dividerTheme.color,
                  height: 1,
                  thickness: 1,
                  indent: ResponsiveHelper.getSpacing(context),
                  endIndent: ResponsiveHelper.getSpacing(context),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNavigationItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
        size: ResponsiveHelper.getIconSize(context),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.responsive(context),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Theme.of(context).colorScheme.secondary,
        size: ResponsiveHelper.getIconSize(context, mobile: 16, tablet: 20, desktop: 24),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(context),
        vertical: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
      ),
      minVerticalPadding: ResponsiveHelper.getListTileHeight(context) / 2,
    );
  }

  Widget _buildToggleItem(IconData icon, String title, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
        size: ResponsiveHelper.getIconSize(context),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.responsive(context),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          }
          return Colors.grey.shade400;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Theme.of(context).colorScheme.primary;
          }
          return Colors.grey.shade300;
        }),
        trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(context),
        vertical: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
      ),
      minVerticalPadding: ResponsiveHelper.getListTileHeight(context) / 2,
    );
  }

  Widget _buildDestructiveItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.error,
        size: AppSpacing.baseIcon,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(context).colorScheme.error,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Theme.of(context).colorScheme.error,
        size: AppSpacing.smIcon,
      ),
      onTap: onTap,
      contentPadding: AppSpacing.padding(horizontal: AppSpacing.base, vertical: AppSpacing.sm),
    );
  }

  void _toggleLanguage() {
    if (_isEnglish) {
      context.setLocale(const Locale('en'));
    } else {
      context.setLocale(const Locale('ar'));
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.baseBorderRadius,
        ),
        title: Text(
          'settings.logout'.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        content: Text(
          'settings.logout_confirmation'.tr(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'settings.cancel'.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: AppTextStyles.semiBold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              print('Logout confirmed');
              // TODO: Implement logout logic
            },
            child: Text(
              'settings.confirm'.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
                fontWeight: AppTextStyles.semiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 