import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../blocs/home_bloc.dart';
import '../../../../../routing/navigation_extension.dart';

class HomePage extends StatefulWidget {
  final String className;
  
  const HomePage({
    super.key,
    required this.className,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadHomeData(widget.className));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.className),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            onPressed: () {
              context.goToSettings();
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is HomeLoaded) {
            return _buildHomeContent(state.data);
          } else if (state is HomeError) {
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
                    'Error loading home data',
                    style: TextStyle(
                      fontSize: 5.w,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(LoadHomeData(widget.className));
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

  Widget _buildHomeContent(HomeData data) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to ${data.className}',
                    style: TextStyle(
                      fontSize: 6.w,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Here\'s what\'s happening today',
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
          
          // Quick Stats
          Text(
            'Quick Stats',
            style: TextStyle(
              fontSize: 5.w,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.people,
                  title: 'Students',
                  value: '${data.totalStudents}',
                  color: Colors.blue,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.check_circle,
                  title: 'Present',
                  value: '${data.presentToday}',
                  color: Colors.green,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 3.h),
          
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.assignment,
                  title: 'Assignments',
                  value: '${data.assignments}',
                  color: Colors.orange,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.announcement,
                  title: 'Announcements',
                  value: '${data.announcements}',
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 4.h),
          
          // Quick Actions
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 5.w,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          
          _buildQuickActionButton(
            icon: Icons.people,
            title: 'Take Attendance',
            onTap: () {
              // TODO: Navigate to attendance page
            },
          ),
          
          SizedBox(height: 2.h),
          
          _buildQuickActionButton(
            icon: Icons.assignment,
            title: 'Create Assignment',
            onTap: () {
              // TODO: Navigate to create assignment page
            },
          ),
          
          SizedBox(height: 2.h),
          
          _buildQuickActionButton(
            icon: Icons.announcement,
            title: 'Post Announcement',
            onTap: () {
              // TODO: Navigate to post announcement page
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Icon(
              icon,
              size: 8.w,
              color: color,
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 6.w,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 3.5.w,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              Icon(
                icon,
                size: 6.w,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 4.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 4.w,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 4.w,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 