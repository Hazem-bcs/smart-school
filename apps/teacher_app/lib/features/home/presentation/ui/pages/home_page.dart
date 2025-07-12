import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../blocs/home_bloc.dart';
import '../../../../../routing/navigation_extension.dart';
import '../../../../../core/responsive_helper.dart';
import '../../../../../core/responsive_widgets.dart';
import '../widgets/class_card.dart';
import '../widgets/assignment_tile.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/bottom_nav_bar_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin {
  late AnimationController _pageAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int _currentIndex = 0;

  // بيانات الفصول
  final List<Map<String, String>> _classes = [
    {
      'title': 'Math 101',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuD9w7tCpSPAzZbbubs-iE5xRO73QdEsyxz7VIrvaDOC2W-5S_ZX_Fang8iFy1YMxgEQYmT9omrIo0qTpXy371S4uAPK8KGB4-8N1TeKR-4AEJdjQQASd9ry1G_I_xy9wV5klMCitHQPmHnglClnCK5RJ4BsNh_fjI7L3lTJSxNk31hD3hCpHT6DfA8vitj9o3wtzF2kEba-_DNsuup5vVxwtOIXUoxtWtdhu4mNST8xLYEhjHevxpBx5tnCVzVtvofVbqEIHBd0Qs-R'
    },
    {
      'title': 'History 202',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBGTNtMBdZd29vc_g_lJKl6sErAKhO3PZ_Z7vYrNQnFstP1RHfWS_D2PIXM2vv-cr_hkFX70XwwzPmpkXrvgDb-XO56z9R2C7dw4wfoz5mNynCbdgZE7DbVEeZPpiZckbfDiKnGU4wBblxNLiYe6loCUzk6bGjlxkTFRhAZSgQJVLEh3nxUSJPxXxPg98krRv9z7GULa3DbDLXi-qJ3aDbSmcCSaI5pGxTrKRKzg5BZwqIVZQW8kLSCE_YBiBVMHGSrb1A7SNjufKhB'
    },
    {
      'title': 'Science 303',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBhhBn8oRkJqk7jGmNa5C2D1sMLpKgtUvUjl6Ydoh9Om0F7cv_EtphZw85Qo-Fcvs-NhDKRAyNiOrjMCVVHNt18SuTEJc-v99b3jSPa32bdX_V63LGcdoF-EttOmh2ty3eZOc0u29OKmRQYSDkRO2cAYrb3iqbP2vbBIsYtTzL3y0sV_C5E9yBk6I3JGStxCTfqQ_mn-wyi9zH7_juJ5EqJdY4V4qC9vMZdu3hG9k2y8xMF5z00HLRfHhTa1LUnPKMcfMGJQnF6WyUM'
    }
  ];

  // بيانات الواجبات
  final List<Map<String, String>> _assignments = [
    {
      'title': 'Essay on World War II',
      'subtitle': 'Due in 2 days'
    },
    {
      'title': 'Math Quiz',
      'subtitle': 'Due in 5 days'
    }
  ];

  // بيانات الإشعارات
  final List<Map<String, String>> _notifications = [
    {
      'title': 'New student joined Math 101',
      'subtitle': '10:00 AM'
    },
    {
      'title': 'Assignment submitted for Math 101',
      'subtitle': 'Yesterday'
    }
  ];

  // عناصر شريط التنقل
  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.home, 'label': 'Dashboard'},
    {'icon': Icons.school, 'label': 'Classes'},
    {'icon': Icons.chat_bubble_outline, 'label': 'Messages'},
    {'icon': Icons.person, 'label': 'Profile'},
  ];

  @override
  void initState() {
    super.initState();
    _pageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pageAnimationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _pageAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _pageAnimationController.forward();
  }

  @override
  void dispose() {
    _pageAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ResponsiveContent(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildClassesSection(),
                  _buildGradingSection(),
                  _buildNotificationsSection(),
                  _buildQuickActionsSection(),
                  SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 80, tablet: 100, desktop: 120)),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF9FAFB),
      elevation: 0,
      title: ResponsiveText(
        'Dashboard',
        mobileSize: 18,
        tabletSize: 20,
        desktopSize: 22,
        style: const TextStyle(
          color: Color(0xFF101418),
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundImage: const NetworkImage(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCwbuL0ZiDMlk21d_cKtbpty8WoXWwySyGPVjGH2-e69ZAKGbiQjraud70q83qALhpx_rFdwh2p3Y0sRc3D7CbjMYdDIdu8fl6SlYiGagcEu5D-0npFOrOSepq90hGqkpXcNeTLbYFZKTO4FDfR6LNKLoRL8MpA7KNHBpbxwjEFIz-oQrL-b0O9FXdHqvKxVNgfpt_21HRS4jKHncoQBHK_lSE9FulUBsR8n6xRMgauziyWJo9exGOKF1w2Rvz_3CZYGEnBeyke2cEZ',
          ),
        ),
      ),
    );
  }

  Widget _buildClassesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context),
            vertical: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
          ),
          child: ResponsiveText(
            'Classes',
            mobileSize: 18,
            tabletSize: 20,
            desktopSize: 22,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF101418),
            ),
          ),
        ),
        SizedBox(
          height: ResponsiveHelper.isMobile(context) ? 180 : 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getSpacing(context),
            ),
            itemCount: _classes.length,
            itemBuilder: (context, index) {
              return ClassCard(
                title: _classes[index]['title']!,
                imageUrl: _classes[index]['imageUrl']!,
                index: index,
                onTap: () => _onClassTap(_classes[index]['title']!),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGradingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
          child: ResponsiveText(
            'Grading',
            mobileSize: 18,
            tabletSize: 20,
            desktopSize: 22,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF101418),
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _assignments.length,
          itemBuilder: (context, index) {
            return AssignmentTile(
              title: _assignments[index]['title']!,
              subtitle: _assignments[index]['subtitle']!,
              icon: Icons.description,
              index: index,
              onTap: () => _onAssignmentTap(_assignments[index]['title']!),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
          child: ResponsiveText(
            'Notifications',
            mobileSize: 18,
            tabletSize: 20,
            desktopSize: 22,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF101418),
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            return AssignmentTile(
              title: _notifications[index]['title']!,
              subtitle: _notifications[index]['subtitle']!,
              icon: Icons.notifications,
              index: index,
              onTap: () => _onNotificationTap(_notifications[index]['title']!),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
          child: ResponsiveText(
            'Quick Actions',
            mobileSize: 18,
            tabletSize: 20,
            desktopSize: 22,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF101418),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context),
            vertical: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
          ),
          child: ResponsiveLayout(
            mobile: Column(
              children: [
                QuickActionButton(
                  text: 'Create Assignment',
                  onPressed: _onCreateAssignment,
                  isPrimary: true,
                  icon: Icons.add,
                ),
                SizedBox(height: ResponsiveHelper.getSpacing(context)),
                QuickActionButton(
                  text: 'Schedule Zoom',
                  onPressed: _onScheduleZoom,
                  isPrimary: false,
                  icon: Icons.video_call,
                ),
              ],
            ),
            tablet: Row(
              children: [
                Expanded(
                  child: QuickActionButton(
                    text: 'Create Assignment',
                    onPressed: _onCreateAssignment,
                    isPrimary: true,
                    icon: Icons.add,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.getSpacing(context)),
                Expanded(
                  child: QuickActionButton(
                    text: 'Schedule Zoom',
                    onPressed: _onScheduleZoom,
                    isPrimary: false,
                    icon: Icons.video_call,
                  ),
                ),
              ],
            ),
            desktop: Row(
              children: [
                Expanded(
                  child: QuickActionButton(
                    text: 'Create Assignment',
                    onPressed: _onCreateAssignment,
                    isPrimary: true,
                    icon: Icons.add,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.getSpacing(context)),
                Expanded(
                  child: QuickActionButton(
                    text: 'Schedule Zoom',
                    onPressed: _onScheduleZoom,
                    isPrimary: false,
                    icon: Icons.video_call,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context),
            vertical: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
          ),
          child: ResponsiveLayout(
            mobile: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _navItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Expanded(
                  child: BottomNavBarItem(
                    icon: item['icon'],
                    label: item['label'],
                    isSelected: index == _currentIndex,
                    onTap: () => _onNavItemTap(index),
                  ),
                );
              }).toList(),
            ),
            tablet: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _navItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return BottomNavBarItem(
                  icon: item['icon'],
                  label: item['label'],
                  isSelected: index == _currentIndex,
                  onTap: () => _onNavItemTap(index),
                );
              }).toList(),
            ),
            desktop: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _navItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return BottomNavBarItem(
                  icon: item['icon'],
                  label: item['label'],
                  isSelected: index == _currentIndex,
                  onTap: () => _onNavItemTap(index),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  // Event handlers
  void _onClassTap(String className) {
    // TODO: Navigate to class details
    print('Class tapped: $className');
  }

  void _onAssignmentTap(String assignmentTitle) {
    // TODO: Navigate to assignment details
    print('Assignment tapped: $assignmentTitle');
  }

  void _onNotificationTap(String notificationTitle) {
    // TODO: Navigate to notification details
    print('Notification tapped: $notificationTitle');
  }

  void _onCreateAssignment() {
    // TODO: Navigate to create assignment
    print('Create Assignment tapped');
  }

  void _onScheduleZoom() {
    // TODO: Navigate to schedule zoom
    print('Schedule Zoom tapped');
  }

  void _onNavItemTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    // TODO: Navigate to different sections
    print('Nav item tapped: ${_navItems[index]['label']}');
  }
} 