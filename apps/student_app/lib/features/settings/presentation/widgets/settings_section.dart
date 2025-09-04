import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/blocs/theme/theme_bloc.dart';
import 'package:core/blocs/theme/theme_event.dart';
import 'package:core/blocs/theme/theme_state.dart';
import '../../../../widgets/responsive/responsive_helper.dart';
import '../../../../widgets/modern_design/modern_effects.dart';

class SettingsSection extends StatelessWidget {
  final ThemeData theme;
  final bool isDark;
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;
  final bool isEnglish;
  final VoidCallback onLanguageToggle;
  final VoidCallback onThemeToggle;

  const SettingsSection({
    Key? key,
    required this.theme,
    required this.isDark,
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
    required this.isEnglish,
    required this.onLanguageToggle,
    required this.onThemeToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context),
        _buildSettingsCard(context),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28),
        vertical: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28),
      ),
      child: Text(
        'التفضيلات',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: ResponsiveHelper.getFontSize(context, mobile: 22, tablet: 24, desktop: 26),
          letterSpacing: 0.5,
          color: isDark ? AppColors.darkPrimaryText : AppColors.gray800,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    return ModernEffects.neumorphism(
      isDark: isDark,
      distance: 6.0,
      intensity: 0.1,
      borderRadius: BorderRadius.circular(20),
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.getSpacing(context)),
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16)),
      child: Column(
        children: [
          _buildNotificationTile(context),
          _buildDivider(),
          _buildLanguageTile(context),
          _buildDivider(),
          _buildThemeTile(context),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(BuildContext context) {
    return _buildModernListTile(
      context: context,
      icon: Icons.notifications_rounded,
      iconColor: isDark ? AppColors.darkAccentBlue : AppColors.primary,
      title: 'الإشعارات',
      subtitle: 'إدارة تفضيلات الإشعارات الخاصة بك',
      trailing: _buildModernSwitch(
        value: notificationsEnabled,
        onChanged: onNotificationsChanged,
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context) {
    return _buildModernListTile(
      context: context,
      icon: Icons.language_rounded,
      iconColor: isDark ? AppColors.darkSuccess : AppColors.success,
      title: 'اللغة',
      subtitle: isEnglish ? 'English' : 'العربية',
      trailing: _buildArrowIcon(),
      onTap: onLanguageToggle,
    );
  }

  Widget _buildThemeTile(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        bool isDarkMode = false;

        if (themeState is ThemeLoaded) {
          isDarkMode = themeState.isDarkMode;
        } else {
          isDarkMode = isDark;
        }

        return _buildModernListTile(
          context: context,
          icon: isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
          iconColor: isDark ? AppColors.darkWarning : AppColors.warning,
          title: 'الوضع الداكن',
          subtitle: isDarkMode ? 'مفعل' : 'معطل',
          trailing: _buildModernSwitch(
            value: isDarkMode,
            onChanged: (_) {
              context.read<ThemeBloc>().add(ToggleTheme());
            },
          ),
        );
      },
    );
  }

  Widget _buildModernListTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
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
                      color: isDark ? AppColors.darkPrimaryText : AppColors.gray800,
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
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildModernSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Transform.scale(
      scale: 1.1,
      child: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: isDark ? AppColors.darkAccentBlue : AppColors.primary,
        activeTrackColor: (isDark ? AppColors.darkAccentBlue : AppColors.primary).withOpacity(0.3),
        inactiveThumbColor: isDark ? AppColors.gray600 : AppColors.gray400,
        inactiveTrackColor: isDark ? AppColors.darkDivider : AppColors.gray200,
      ),
    );
  }

  Widget _buildArrowIcon() {
    return Container(
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
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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