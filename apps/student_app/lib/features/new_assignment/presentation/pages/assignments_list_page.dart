import 'package:core/theme/app_bar_theme.dart';
import 'package:core/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:smart_school/widgets/app_bar_widget.dart';
import 'package:smart_school/widgets/shared_bottom_navigation.dart';
import '../../domain/entities/assignment_entity.dart';
import '../../domain/usecases/get_assignments_usecase.dart';
import '../../data/repositories_impl/assignment_repository_impl.dart';
import '../../data/data_sources/assignment_remote_data_source.dart';
import '../widgets/assignment_card.dart';

enum AssignmentFilter { all, graded, ungraded }

class AssignmentsListPage extends StatefulWidget {
  const AssignmentsListPage({super.key});

  @override
  State<AssignmentsListPage> createState() => _AssignmentsListPageState();
}

class _AssignmentsListPageState extends State<AssignmentsListPage>
    with TickerProviderStateMixin {
  final GetAssignmentsUseCase getAssignmentsUseCase = GetAssignmentsUseCase(
    AssignmentRepositoryImpl(AssignmentRemoteDataSourceImpl()),
  );

  AssignmentFilter _selectedFilter = AssignmentFilter.all;
  List<AssignmentEntity> _allAssignments = [];
  List<AssignmentEntity> _filteredAssignments = [];
  late Future<List<AssignmentEntity>> _assignmentsFuture;

  // Animation controllers
  late AnimationController _fadeAnimationController;
  late AnimationController _slideAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _assignmentsFuture = _fetchAssignments();
  }

  void _initializeAnimations() {
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimationController.forward();
    _slideAnimationController.forward();
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    _slideAnimationController.dispose();
    super.dispose();
  }

  Future<List<AssignmentEntity>> _fetchAssignments() async {
    final result = await getAssignmentsUseCase('class_a');
    return result.fold(
          (failure) => throw failure,
          (assignments) {
        _allAssignments = assignments;
        _applyFilter();
        return _allAssignments;
      },
    );
  }

  void _applyFilter() {
    setState(() {
      List<AssignmentEntity> tempAssignments;

      switch (_selectedFilter) {
        case AssignmentFilter.all:
          tempAssignments = _allAssignments;
          break;
        case AssignmentFilter.graded:
          tempAssignments = _allAssignments.where((a) => a.submissionStatus == SubmissionStatus.graded).toList();
          break;
        case AssignmentFilter.ungraded:
          tempAssignments = _allAssignments.where((a) => a.submissionStatus != SubmissionStatus.graded).toList();
          break;
      }

      // الترتيب: المهام الجديدة أولاً، ثم المهام حسب تاريخ التسليم
      tempAssignments.sort((a, b) {
        final isNewA = DateTime.now().difference(a.createdAt).inHours <= 48;
        final isNewB = DateTime.now().difference(b.createdAt).inHours <= 48;

        if (isNewA && !isNewB) return -1;
        if (!isNewA && isNewB) return 1;

        return a.dueDate.compareTo(b.dueDate);
      });

      _filteredAssignments = tempAssignments;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: FutureBuilder<List<AssignmentEntity>>(
            future: _assignmentsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingState();
              } else if (snapshot.hasError) {
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _assignmentsFuture = _fetchAssignments();
                    });
                  },
                  color: const Color(0xFF7B61FF),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
                      child: _buildErrorState(snapshot.error.toString()),
                    ),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _assignmentsFuture = _fetchAssignments();
                    });
                  },
                  color: const Color(0xFF7B61FF),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
                      child: _buildEmptyState(),
                    ),
                  ),
                );
              } else {
                return _buildContent(context, theme, isDark);
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: SharedBottomNavigation(
        currentIndex: 1, // Assignments tab
        onTap: (int index) {},
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    
    return AppBarWidget(
      title: 'المهام الدراسية',
      gradientType: GradientType.primary,
      actions: [
        AppBarActions.refresh(
          onPressed: () {
            setState(() {
              _assignmentsFuture = _fetchAssignments();
            });
          },
          isDark: isDark,
        ),
        AppBarActions.counter(
          text: '${_filteredAssignments.length} مهمة',
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const SmartSchoolLoading(
      message: 'جاري تحميل المهام...',
      type: LoadingType.primary,
      size: 80.0,
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ في التحميل',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _assignmentsFuture = _fetchAssignments();
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7B61FF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.assignment_outlined,
              size: 48,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'لا توجد مهام حالياً',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ستظهر المهام الجديدة هنا عند إضافتها',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme, bool isDark) {
    return Column(
      children: [
        _buildFilterSection(theme),
        const SizedBox(height: 16),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _assignmentsFuture = _fetchAssignments();
              });
            },
            color: const Color(0xFF7B61FF),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredAssignments.length,
              itemBuilder: (context, index) {
                final assignment = _filteredAssignments[index];
                return AnimatedBuilder(
                  animation: _fadeAnimationController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - _fadeAnimation.value)),
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: AssignmentCard(
                          assignment: assignment,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/assignment_details',
                              arguments: assignment,
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تصفية المهام',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildFilterChip('الكل', AssignmentFilter.all, theme),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterChip('مُقيّمة', AssignmentFilter.graded, theme),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterChip('غير مُقيّمة', AssignmentFilter.ungraded, theme),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String text, AssignmentFilter filter, ThemeData theme) {
    final isSelected = _selectedFilter == filter;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = filter;
        });
        _applyFilter();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF7B61FF)
              : theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF7B61FF)
                : Colors.grey.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: const Color(0xFF7B61FF).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}