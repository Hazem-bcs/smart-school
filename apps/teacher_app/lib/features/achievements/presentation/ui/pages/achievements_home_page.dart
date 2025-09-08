import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/theme/index.dart';
import 'package:teacher_app/core/routing/navigation_extension.dart';
import 'package:teacher_app/core/responsive/responsive_helper.dart';
import '../../blocs/achievements_bloc.dart';
import '../../blocs/achievements_event.dart';
import '../../blocs/achievements_state.dart';
import '../widgets/animated_search_bar.dart';
import '../widgets/student_card.dart';
import '../widgets/achievement_grid.dart';
import '../widgets/loading_animation.dart';
import '../widgets/error_widget.dart' as custom_error;

class AchievementsHomePage extends StatefulWidget {
  const AchievementsHomePage({super.key});

  @override
  State<AchievementsHomePage> createState() => _AchievementsHomePageState();
}

class _AchievementsHomePageState extends State<AchievementsHomePage>
    with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _contentAnimationController;
  late Animation<double> _headerAnimation;
  late Animation<double> _contentAnimation;

  final TextEditingController _searchController = TextEditingController();
  String? _selectedClassroom;
  String? _selectedStudentId;
  String? _selectedStudentName;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadInitialData();
  }

  void _initializeAnimations() {
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _headerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _contentAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentAnimationController,
      curve: Curves.easeOutBack,
    ));

    _headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _contentAnimationController.forward();
    });
  }

  void _loadInitialData() {
    context.read<AchievementsBloc>().add(LoadStudents());
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _contentAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Animated Header
            AnimatedBuilder(
              animation: _headerAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -50 * (1 - _headerAnimation.value)),
                  child: Opacity(
                    opacity: _headerAnimation.value.clamp(0.0, 1.0),
                    child: _buildAnimatedHeader(isDark),
                  ),
                );
              },
            ),

            // Main Content
            Expanded(
              child: AnimatedBuilder(
                animation: _contentAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 30 * (1 - _contentAnimation.value)),
                    child: Opacity(
                      opacity: _contentAnimation.value.clamp(0.0, 1.0),
                      child: _buildMainContent(isDark),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader(bool isDark) {
    return Container(
      height: ResponsiveHelper.isMobile(context) ? 260 : 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.darkAccentBlue, AppColors.darkAccentPurple]
              : [AppColors.info, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(ResponsiveHelper.getBorderRadius(context) * 2),
          bottomRight: Radius.circular(ResponsiveHelper.getBorderRadius(context) * 2),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Decorative Elements
          Positioned(
            top: 10,
            right: -20,
            child: _buildFloatingIcon(Icons.workspace_premium, 60, 0.2),
          ),
          Positioned(
            bottom: -15,
            left: -15,
            child: _buildFloatingIcon(Icons.star, 80, 0.15),
          ),
          Positioned(
            top: 80,
            left: 15,
            child: _buildFloatingIcon(Icons.emoji_events, 50, 0.1),
          ),

          // Header Content
          Padding(
            padding: ResponsiveHelper.getScreenPadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Back Button and Title
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'منح الإنجازات',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveHelper.getFontSize(context, mobile: 24, tablet: 28, desktop: 32),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _selectedStudentId == null
                                ? 'اختر الطالب ثم منح الإنجاز المناسب'
                                : 'إنجازات ${_selectedStudentName ?? ''}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.list_alt, color: Colors.white),
                        onPressed: () {
                          context.goToStudentsList();
                        },
                        tooltip: 'قائمة الطلاب',
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.workspace_premium,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Search Bar
                AnimatedSearchBar(
                  controller: _searchController,
                  onSearch: _onSearch,
                  onFilterChanged: _onFilterChanged,
                  selectedClassroom: _selectedClassroom,
                  isStudentSelected: _selectedStudentId != null,
                  onBackToStudents: _backToStudentsList,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingIcon(IconData icon, double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: size * 0.4,
      ),
    );
  }

  Widget _buildMainContent(bool isDark) {
    return BlocConsumer<AchievementsBloc, AchievementsState>(
      listener: (context, state) {
        if (state is AchievementGranted) {
          _showSuccessSnackBar(state.message);
          // Reload student achievements
          if (_selectedStudentId != null) {
            context.read<AchievementsBloc>().add(
              LoadStudentAchievements(studentId: _selectedStudentId!),
            );
          }
        } else if (state is AchievementRevoked) {
          _showSuccessSnackBar(state.message);
          // Reload student achievements
          if (_selectedStudentId != null) {
            context.read<AchievementsBloc>().add(
              LoadStudentAchievements(studentId: _selectedStudentId!),
            );
          }
        } else if (state is AchievementsError) {
          _showErrorSnackBar(state.message);
        }
      },
      builder: (context, state) {
        if (state is AchievementsLoading) {
          return const LoadingAnimation();
        }

        if (state is AchievementsError) {
          return custom_error.ErrorWidget(
            message: state.message,
            onRetry: _onSearch,
          );
        }

        if (_selectedStudentId != null) {
          if (state is StudentAchievementsLoaded) {
            return AchievementGrid(
              achievements: state.achievements,
              studentId: _selectedStudentId!,
              studentName: _selectedStudentName!,
              onGrantAchievement: _grantAchievement,
              onRevokeAchievement: _revokeAchievement,
            );
          }
          return const LoadingAnimation();
        }

        if (state is StudentsLoaded) {
          return _buildStudentsList(state.students, isDark);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStudentsList(List students, bool isDark) {
    if (students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 60,
              color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
            ),
            const SizedBox(height: 12),
            Text(
              'لا توجد نتائج',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: ResponsiveHelper.getScreenPadding(context),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 100)),
          curve: Curves.easeOutBack,
          child: StudentCard(
            student: student,
            onTap: () {
              context.goToStudentAchievements(student.id, student.name);
            },
          ),
        );
      },
    );
  }

  void _onSearch() {
    context.read<AchievementsBloc>().add(
      LoadStudents(
        searchQuery: _searchController.text.trim().isEmpty
            ? null
            : _searchController.text.trim(),
        classroom: _selectedClassroom,
      ),
    );
  }

  void _onFilterChanged(String? classroom) {
    setState(() {
      _selectedClassroom = classroom;
    });
    _onSearch();
  }


  void _backToStudentsList() {
    setState(() {
      _selectedStudentId = null;
      _selectedStudentName = null;
    });
    _onSearch();
  }

  void _grantAchievement(String achievementId) {
    if (_selectedStudentId != null) {
      context.read<AchievementsBloc>().add(
        GrantAchievement(
          studentId: _selectedStudentId!,
          achievementId: achievementId,
        ),
      );
    }
  }

  void _revokeAchievement(String achievementId) {
    if (_selectedStudentId != null) {
      context.read<AchievementsBloc>().add(
        RevokeAchievement(
          studentId: _selectedStudentId!,
          achievementId: achievementId,
        ),
      );
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
