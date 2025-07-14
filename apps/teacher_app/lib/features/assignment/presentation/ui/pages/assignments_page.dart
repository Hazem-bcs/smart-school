import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../../core/responsive_helper.dart';
import '../../../../../core/responsive_widgets.dart';
import '../widgets/assignment_list_tile.dart';
import '../widgets/filter_chip.dart' as custom;
import '../../../domain/models/assignment.dart';
import 'new_assignment_page.dart';
import '../../../../home/presentation/ui/pages/home_page.dart';
import '../../../../../widgets/shared_bottom_navigation.dart';
import 'package:core/theme/constants/app_colors.dart';

class AssignmentsPage extends StatefulWidget {
  const AssignmentsPage({super.key});

  @override
  State<AssignmentsPage> createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage>
    with TickerProviderStateMixin {
  late AnimationController _pageAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Search and filter state
  final TextEditingController _searchController = TextEditingController();
  AssignmentStatus _selectedFilter = AssignmentStatus.all;
  String _searchQuery = '';
  Timer? _debounceTimer;

  // Sample data
  final List<Assignment> _allAssignments = [
    Assignment(
      id: '1',
      title: 'Math Quiz 1',
      subtitle: 'Due: Oct 26 · 25/25 submitted',
      isCompleted: true,
      dueDate: DateTime(2024, 10, 26),
      submittedCount: 25,
      totalCount: 25,
      status: AssignmentStatus.graded,
    ),
    Assignment(
      id: '2',
      title: 'Science Project',
      subtitle: 'Due: Oct 27 · 20/25 submitted',
      isCompleted: false,
      dueDate: DateTime(2024, 10, 27),
      submittedCount: 20,
      totalCount: 25,
      status: AssignmentStatus.ungraded,
    ),
    Assignment(
      id: '3',
      title: 'English Essay',
      subtitle: 'Due: Oct 28 · 25/25 submitted',
      isCompleted: true,
      dueDate: DateTime(2024, 10, 28),
      submittedCount: 25,
      totalCount: 25,
      status: AssignmentStatus.graded,
    ),
    Assignment(
      id: '4',
      title: 'History Report',
      subtitle: 'Due: Oct 29 · 22/25 submitted',
      isCompleted: false,
      dueDate: DateTime(2024, 10, 29),
      submittedCount: 22,
      totalCount: 25,
      status: AssignmentStatus.ungraded,
    ),
    Assignment(
      id: '5',
      title: 'Art Portfolio',
      subtitle: 'Due: Oct 30 · 25/25 submitted',
      isCompleted: true,
      dueDate: DateTime(2024, 10, 30),
      submittedCount: 25,
      totalCount: 25,
      status: AssignmentStatus.graded,
    ),
  ];

  // Filter options
  final List<Map<String, dynamic>> _filterOptions = [
    {'label': 'All', 'status': AssignmentStatus.all},
    {'label': 'Ungraded', 'status': AssignmentStatus.ungraded},
    {'label': 'Graded', 'status': AssignmentStatus.graded},
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

    // Add search listener with debouncing
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _pageAnimationController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: ResponsiveText(
          'Assignments',
          mobileSize: 18,
          tabletSize: 20,
          desktopSize: 22,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.appBarTheme.foregroundColor ?? (isDark ? Colors.white : const Color(0xFF0E141B)),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: theme.iconTheme.color ?? (isDark ? Colors.white : const Color(0xFF0E141B))),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewAssignmentPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ResponsiveContent(
            child: Column(
              children: [
                _buildSearchField(),
                _buildFilterChips(),
                Expanded(
                  child: _buildAssignmentsList(theme, isDark),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SharedBottomNavigation(
        currentIndex: 1, // Assignments is selected
        onNavItemTap: _onNavItemTap,
      ),
    );
  }

  Widget _buildSearchField() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24),
        vertical: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
      ),
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
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: isDark ? AppColors.info : AppColors.primary,
            size: ResponsiveHelper.getIconSize(context, mobile: 20, tablet: 24, desktop: 28),
          ),
          SizedBox(width: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20)),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search assignments',
                border: InputBorder.none,
                isDense: true,
              ),
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: ResponsiveHelper.getSpacing(context, mobile: 50, tablet: 60, desktop: 70),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getSpacing(context),
        ),
        itemCount: _filterOptions.length,
        itemBuilder: (context, index) {
          final option = _filterOptions[index];
          final isSelected = _selectedFilter == option['status'];
          
          return custom.FilterChip(
            label: option['label'],
            isSelected: isSelected,
            onTap: () => _onFilterChanged(option['status']),
          );
        },
      ),
    );
  }

  Widget _buildAssignmentsList(ThemeData theme, bool isDark) {
    final filteredAssignments = _getFilteredAssignments();

    if (filteredAssignments.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
          vertical: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
        ),
        itemCount: filteredAssignments.length,
        separatorBuilder: (context, index) => SizedBox(
          height: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20),
        ),
        itemBuilder: (context, index) {
          final assignment = filteredAssignments[index];
          return Card(
            color: isDark ? AppColors.darkCardBackground : theme.cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            shadowColor: isDark ? Colors.black.withOpacity(0.15) : Colors.grey.withOpacity(0.08),
            margin: EdgeInsets.zero,
            child: AssignmentListTile(
              title: assignment.title,
              subtitle: assignment.subtitle,
              isCompleted: assignment.isCompleted,
              index: index,
              onTap: () => _onAssignmentTap(assignment),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: ResponsiveHelper.getIconSize(context, mobile: 80, tablet: 100, desktop: 120),
            color: Colors.grey[400],
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24)),
          ResponsiveText(
            _searchQuery.isNotEmpty ? 'No assignments found' : 'No assignments yet',
            mobileSize: 18,
            tabletSize: 20,
            desktopSize: 22,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16)),
          ResponsiveText(
            _searchQuery.isNotEmpty 
                ? 'Try adjusting your search or filters'
                : 'Create your first assignment to get started',
            mobileSize: 14,
            tabletSize: 16,
            desktopSize: 18,
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }



  // Helper methods
  List<Assignment> _getFilteredAssignments() {
    List<Assignment> filtered = _allAssignments;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((assignment) {
        return assignment.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               assignment.subtitle.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply status filter
    if (_selectedFilter != AssignmentStatus.all) {
      filtered = filtered.where((assignment) {
        return assignment.status == _selectedFilter;
      }).toList();
    }

    return filtered;
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  void _onFilterChanged(AssignmentStatus status) {
    setState(() {
      _selectedFilter = status;
    });
  }

  Future<void> _onRefresh() async {
    // TODO: Implement refresh logic
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Refresh data
    });
  }

  void _onAssignmentTap(Assignment assignment) {
    // TODO: Navigate to assignment details
    // print('Assignment tapped: ${assignment.title}');
  }

  void _onNavItemTap(int index) {
    switch (index) {
      case 0: // Dashboard
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
        break;
      case 1: // Assignments
        // Already on Assignments page
        break;
      case 2: // Students
        // TODO: Navigate to Students page
        print('Students page not implemented yet');
        break;
      case 3: // Settings
        // TODO: Navigate to Settings page
        print('Settings page not implemented yet');
        break;
    }
  }
} 