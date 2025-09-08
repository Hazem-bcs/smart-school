import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/theme/index.dart';
import 'package:teacher_app/core/routing/navigation_extension.dart';
import 'package:teacher_app/features/achievements/presentation/blocs/achievements_bloc.dart';
import 'package:teacher_app/features/achievements/presentation/blocs/achievements_event.dart';
import 'package:teacher_app/features/achievements/presentation/blocs/achievements_state.dart';
import 'package:teacher_app/features/achievements/presentation/ui/widgets/student_card.dart';
import 'package:teacher_app/features/achievements/presentation/ui/widgets/animated_search_bar.dart';
import 'package:teacher_app/features/achievements/presentation/ui/widgets/loading_animation.dart';
import '../widgets/error_widget.dart' as custom_error;

class StudentsListPage extends StatefulWidget {
  const StudentsListPage({super.key});

  @override
  State<StudentsListPage> createState() => _StudentsListPageState();
}

class _StudentsListPageState extends State<StudentsListPage>
    with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _contentAnimationController;
  late Animation<double> _headerAnimation;
  late Animation<double> _contentAnimation;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    context.read<AchievementsBloc>().add(LoadStudents());
  }

  void _initializeAnimations() {
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
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
      curve: Curves.easeOutCubic,
    ));

    _headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _contentAnimationController.forward();
    });
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          _buildAnimatedHeader(isDark),
          Expanded(
            child: AnimatedBuilder(
              animation: _contentAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - _contentAnimation.value)),
                  child: Opacity(
                    opacity: _contentAnimation.value,
                    child: _buildContent(isDark),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedHeader(bool isDark) {
    return AnimatedBuilder(
      animation: _headerAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -50 * (1 - _headerAnimation.value)),
          child: Opacity(
            opacity: _headerAnimation.value,
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          AppColors.primary,
                          AppColors.darkAccentBlue,
                        ]
                      : [
                          AppColors.primary,
                          AppColors.accent,
                        ],
                ),
              ),
              child: Stack(
                children: [
                  // Decorative shapes
                  Positioned(
                    top: -50,
                    right: -50,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -30,
                    left: -30,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  // Content
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'قائمة الطلاب',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          AnimatedSearchBar(
                            controller: _searchController,
                            onSearch: () {
                              context.read<AchievementsBloc>().add(LoadStudents(searchQuery: _searchController.text));
                            },
                            onFilterChanged: (className) {
                              context.read<AchievementsBloc>().add(
                                LoadStudents(classroom: className),
                              );
                            },
                            isStudentSelected: false,
                            onBackToStudents: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(bool isDark) {
    return BlocConsumer<AchievementsBloc, AchievementsState>(
      listener: (context, state) {
        if (state is AchievementsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: isDark ? AppColors.darkError : AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is AchievementsLoading) {
          return const Center(
            child: LoadingAnimation(),
          );
        }

        if (state is AchievementsError) {
          return Center(
            child: custom_error.ErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<AchievementsBloc>().add(LoadStudents());
              },
            ),
          );
        }

        if (state is StudentsLoaded) {
                        if (state.displayStudents.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد نتائج',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'جرب البحث بكلمات مختلفة',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<AchievementsBloc>().add(LoadStudents());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.displayStudents.length,
              itemBuilder: (context, index) {
                            final student = state.displayStudents[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: StudentCard(
                    student: student,
                    onTap: () {
                      context.goToStudentAchievements(student.id, student.name);
                    },
                  ),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
