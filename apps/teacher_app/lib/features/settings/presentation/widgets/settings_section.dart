import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/responsive/responsive_helper.dart';
import 'package:core/theme/index.dart';
import 'package:core/blocs/theme/theme_bloc.dart';
import 'package:core/blocs/theme/theme_event.dart';
import 'package:core/blocs/theme/theme_state.dart';

class SettingsSection extends StatelessWidget {
  final ThemeData theme;
  final bool isDark;
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;
  final bool isEnglish;
  final VoidCallback onLanguageToggle;
  final VoidCallback onThemeToggle;

  const SettingsSection({
    super.key,
    required this.theme,
    required this.isDark,
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
    required this.isEnglish,
    required this.onLanguageToggle,
    required this.onThemeToggle,
  });

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
              BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, themeState) {
                  bool isDarkMode = false;
                  
                  if (themeState is ThemeLoaded) {
                    isDarkMode = themeState.isDarkMode;
                  } else {
                    isDarkMode = isDark;
                  }
                  
                  return ListTile(
                    leading: Icon(
                      isDarkMode ? Icons.dark_mode : Icons.light_mode, 
                      color: theme.iconTheme.color
                    ),
                    title: Text('Dark Mode', style: theme.textTheme.titleMedium),
                    subtitle: Text(isDarkMode ? 'Enabled' : 'Disabled'),
                    trailing: Switch(
                      value: isDarkMode,
                      onChanged: (_) {
                        context.read<ThemeBloc>().add(ToggleTheme());
                        onThemeToggle();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
} 