import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import '../../blocs/settings_bloc.dart';
import '../../../../../routing/navigation_extension.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(const LoadSettings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('teacher.settings'.tr()),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SettingsLoaded) {
            return _buildSettingsContent(state.settings);
          } else if (state is SettingsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 15.w,
                    color: Colors.red,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Error loading settings',
                    style: TextStyle(
                      fontSize: 5.w,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SettingsBloc>().add(const LoadSettings());
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSettingsContent(SettingsModel settings) {
    return ListView(
      padding: EdgeInsets.all(4.w),
      children: [
        // Notifications Section
        _buildSectionCard(
          title: 'Notifications',
          icon: Icons.notifications,
          children: [
            SwitchListTile(
              title: Text(
                'Enable Notifications',
                style: TextStyle(fontSize: 4.w),
              ),
              subtitle: Text(
                'Receive notifications for important updates',
                style: TextStyle(fontSize: 3.5.w, color: Colors.grey[600]),
              ),
              value: settings.notifications,
              onChanged: (value) {
                final newSettings = settings.copyWith(notifications: value);
                context.read<SettingsBloc>().add(UpdateSettings(newSettings));
              },
            ),
          ],
        ),
        
        SizedBox(height: 3.h),
        
        // Appearance Section
        _buildSectionCard(
          title: 'Appearance',
          icon: Icons.palette,
          children: [
            SwitchListTile(
              title: Text(
                'Dark Mode',
                style: TextStyle(fontSize: 4.w),
              ),
              subtitle: Text(
                'Use dark theme',
                style: TextStyle(fontSize: 3.5.w, color: Colors.grey[600]),
              ),
              value: settings.darkMode,
              onChanged: (value) {
                final newSettings = settings.copyWith(darkMode: value);
                context.read<SettingsBloc>().add(UpdateSettings(newSettings));
              },
            ),
          ],
        ),
        
        SizedBox(height: 3.h),
        
        // Language Section
        _buildSectionCard(
          title: 'Language',
          icon: Icons.language,
          children: [
            ListTile(
              title: Text(
                'Current Language',
                style: TextStyle(fontSize: 4.w),
              ),
              subtitle: Text(
                settings.language == 'en' ? 'English' : 'العربية',
                style: TextStyle(fontSize: 3.5.w, color: Colors.grey[600]),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 4.w),
              onTap: () {
                // TODO: Show language selection dialog
              },
            ),
          ],
        ),
        
        SizedBox(height: 3.h),
        
        // Sync Section
        _buildSectionCard(
          title: 'Data & Sync',
          icon: Icons.sync,
          children: [
            SwitchListTile(
              title: Text(
                'Auto Sync',
                style: TextStyle(fontSize: 4.w),
              ),
              subtitle: Text(
                'Automatically sync data when online',
                style: TextStyle(fontSize: 3.5.w, color: Colors.grey[600]),
              ),
              value: settings.autoSync,
              onChanged: (value) {
                final newSettings = settings.copyWith(autoSync: value);
                context.read<SettingsBloc>().add(UpdateSettings(newSettings));
              },
            ),
          ],
        ),
        
        SizedBox(height: 4.h),
        
        // About Section
        _buildSectionCard(
          title: 'About',
          icon: Icons.info,
          children: [
            ListTile(
              title: Text(
                'App Version',
                style: TextStyle(fontSize: 4.w),
              ),
              subtitle: Text(
                '1.0.0',
                style: TextStyle(fontSize: 3.5.w, color: Colors.grey[600]),
              ),
            ),
            ListTile(
              title: Text(
                'Terms of Service',
                style: TextStyle(fontSize: 4.w),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 4.w),
              onTap: () {
                // TODO: Navigate to terms of service
              },
            ),
            ListTile(
              title: Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 4.w),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 4.w),
              onTap: () {
                // TODO: Navigate to privacy policy
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  size: 6.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 5.w,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ...children,
          ],
        ),
      ),
    );
  }
} 