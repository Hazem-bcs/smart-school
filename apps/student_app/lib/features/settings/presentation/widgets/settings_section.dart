import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';
import '../../../../widgets/responsive/responsive_helper.dart';

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
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28),
            vertical: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24),
          ),
          child: Text(
            'Preferences',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
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
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.notifications, color: theme.iconTheme.color),
                title: Text('Notifications', style: theme.textTheme.titleMedium),
                subtitle: Text('Manage your notification preferences'),
                trailing: Switch(
                  value: notificationsEnabled,
                  onChanged: onNotificationsChanged,
                ),
              ),
              ListTile(
                leading: Icon(Icons.language, color: theme.iconTheme.color),
                title: Text('Language', style: theme.textTheme.titleMedium),
                subtitle: Text(isEnglish ? 'English' : 'العربية'),
                trailing: Icon(Icons.arrow_forward_ios, color: theme.iconTheme.color),
                onTap: onLanguageToggle,
              ),
              ListTile(
                leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: theme.iconTheme.color),
                title: Text('Dark Mode', style: theme.textTheme.titleMedium),
                subtitle: Text(isDark ? 'Enabled' : 'Disabled'),
                trailing: Switch(
                  value: isDark,
                  onChanged: (_) => onThemeToggle(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 