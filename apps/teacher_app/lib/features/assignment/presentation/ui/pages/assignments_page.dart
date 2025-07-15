import 'package:flutter/material.dart';
import 'package:teacher_app/features/assignment/domain/entities/assignment.dart';
import 'dart:async';
import '../../../../../core/responsive/responsive_helper.dart';
import '../../../../../core/responsive/responsive_widgets.dart';
import '../widgets/assignment_list_tile.dart';
import 'new_assignment_page.dart';
import '../../../../../core/widgets/shared_bottom_navigation.dart';
import 'package:core/theme/constants/app_colors.dart';
import '../../../../../core/routing/navigation_extension.dart';
import '../widgets/assignments_app_bar.dart';
import '../widgets/assignments_search_field.dart';
import '../widgets/assignments_filter_chips.dart';
import '../widgets/assignments_empty_state.dart';

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
      appBar: AssignmentsAppBar(
        title: 'Assignments',
        onAdd: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewAssignmentPage(),
            ),
          );
        },
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ResponsiveContent(
            child: Column(
              children: [
                AssignmentsSearchField(controller: _searchController),
                AssignmentsFilterChips(
                  filterOptions: _filterOptions,
                  selectedFilter: _selectedFilter,
                  onChanged: _onFilterChanged,
                ),
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
      ),
    );
  }

  Widget _buildAssignmentsList(ThemeData theme, bool isDark) {
    final filteredAssignments = _getFilteredAssignments();

    if (filteredAssignments.isEmpty) {
      return AssignmentsEmptyState(searchQuery: _searchQuery);
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
    // تم تبسيط منطق التحديث ليكون Placeholder واضح فقط
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {});
  }

  void _onAssignmentTap(Assignment assignment) {
    context.goToAssignmentSubmission(assignment.id);
  }
} 