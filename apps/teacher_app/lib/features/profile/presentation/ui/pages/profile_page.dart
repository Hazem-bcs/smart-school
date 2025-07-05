import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import '../../blocs/profile_bloc.dart';
import '../../../../../routing/navigation_extension.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const LoadProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('teacher.profile'.tr()),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Navigate to edit profile
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProfileLoaded) {
            return _buildProfileContent(state.profile);
          } else if (state is ProfileError) {
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
                    'Error loading profile',
                    style: TextStyle(
                      fontSize: 5.w,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProfileBloc>().add(const LoadProfile());
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

  Widget _buildProfileContent(ProfileModel profile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Profile Header
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 15.w,
                    backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    child: profile.avatar != null
                        ? ClipOval(
                            child: Image.network(
                              profile.avatar!,
                              width: 30.w,
                              height: 30.w,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 15.w,
                            color: Theme.of(context).primaryColor,
                          ),
                  ),
                  SizedBox(height: 3.h),
                  
                  // Name
                  Text(
                    profile.name,
                    style: TextStyle(
                      fontSize: 6.w,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  
                  // Subject
                  Text(
                    profile.subject,
                    style: TextStyle(
                      fontSize: 4.w,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 4.h),
          
          // Profile Details
          _buildSectionCard(
            title: 'Personal Information',
            icon: Icons.person,
            children: [
              _buildInfoRow(
                icon: Icons.email,
                label: 'Email',
                value: profile.email,
              ),
              _buildInfoRow(
                icon: Icons.phone,
                label: 'Phone',
                value: profile.phone,
              ),
              _buildInfoRow(
                icon: Icons.school,
                label: 'Subject',
                value: profile.subject,
              ),
              _buildInfoRow(
                icon: Icons.work,
                label: 'Experience',
                value: profile.experience,
              ),
            ],
          ),
          
          SizedBox(height: 3.h),
          
          // Quick Actions
          _buildSectionCard(
            title: 'Quick Actions',
            icon: Icons.settings,
            children: [
              _buildActionTile(
                icon: Icons.edit,
                title: 'Edit Profile',
                onTap: () {
                  // TODO: Navigate to edit profile
                },
              ),
              _buildActionTile(
                icon: Icons.lock,
                title: 'Change Password',
                onTap: () {
                  // TODO: Navigate to change password
                },
              ),
              _buildActionTile(
                icon: Icons.notifications,
                title: 'Notification Settings',
                onTap: () {
                  // TODO: Navigate to notification settings
                },
              ),
              _buildActionTile(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () {
                  // TODO: Show logout confirmation
                },
                isDestructive: true,
              ),
            ],
          ),
        ],
      ),
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 5.w,
            color: Colors.grey[600],
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 3.5.w,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 4.w,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : Theme.of(context).primaryColor,
        size: 5.w,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 4.w,
          color: isDestructive ? Colors.red : null,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 4.w,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }
} 