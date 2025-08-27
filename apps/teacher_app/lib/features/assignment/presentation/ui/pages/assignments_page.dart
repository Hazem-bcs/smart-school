import 'package:flutter/material.dart';
import 'package:teacher_app/features/assignment/domain/entities/assignment.dart';
import 'dart:async';
import '../../../../../core/responsive/responsive_widgets.dart';
import '../../../../../core/widgets/shared_bottom_navigation.dart';
import '../../../../../core/routing/navigation_extension.dart';
import '../widgets/assignments_app_bar.dart';
import '../widgets/assignments_search_field.dart';
import '../widgets/assignments_filter_chips.dart';
import '../widgets/assignments_empty_state.dart';
import '../widgets/assignments_error_state.dart';
import '../widgets/assignments_loading_state.dart';
import '../widgets/assignments_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/assignment_bloc.dart';
import '../../blocs/assignment_event.dart';
import '../../blocs/assignment_state.dart';

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
  Timer? _debounceTimer;

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

    // عند بدء الصفحة، أرسل حدث تحميل الواجبات
    context.read<AssignmentBloc>().add(const LoadAssignments());

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
          context.goToNewAssignment();
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
                  child: BlocBuilder<AssignmentBloc, AssignmentState>(
                    builder: (context, state) {
                      if (state is AssignmentLoading) {
                        return const AssignmentsLoadingState();
                      } else if (state is AssignmentLoaded) {
                        final assignments = state.assignments;
                        if (assignments.isEmpty) {
                          return AssignmentsEmptyState(searchQuery: _searchController.text);
                        }
                        return AssignmentsList(
                          assignments: assignments,
                          isDark: isDark,
                          onAssignmentTap: _onAssignmentTap,
                          onRefresh: () => _onRefresh(),
                        );
                      } else if (state is AssignmentError) {
                        return AssignmentsErrorState(
                          message: state.message,
                          searchQuery: _searchController.text.isNotEmpty ? _searchController.text : null,
                          filter: _selectedFilter.toString().split('.').last,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
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

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _loadAssignmentsWithCurrentFilters();
    });
  }

  void _onFilterChanged(AssignmentStatus status) {
    setState(() {
      _selectedFilter = status;
    });
    _loadAssignmentsWithCurrentFilters();
  }

  Future<void> _onRefresh() async {
    _loadAssignmentsWithCurrentFilters();
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _loadAssignmentsWithCurrentFilters() {
    context.read<AssignmentBloc>().add(
      LoadAssignments(
        searchQuery: _searchController.text.isNotEmpty ? _searchController.text : null,
        filter: _selectedFilter,
      ),
    );
  }

  void _onAssignmentTap(Assignment assignment) {
    context.goToAssignmentSubmission(assignment.id);
  }
}