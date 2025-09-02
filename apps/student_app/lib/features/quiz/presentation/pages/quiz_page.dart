import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homework/domain/entites/homework_entity.dart';
import 'package:smart_school/routing/index.dart';
import 'package:smart_school/widgets/app_exports.dart';
import 'package:core/theme/index.dart';
import '../../../../widgets/modern_design/modern_effects.dart';
import '../blocs/home_work_bloc/homework_bloc.dart';
import 'one_quiz_page.dart';

class HomeworkPage extends StatefulWidget {
  const HomeworkPage({super.key});

  @override
  State<HomeworkPage> createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    context.read<HomeworkBloc>().add(GetHomeworksEvent());
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
      appBar: _buildAppBar(theme, isDark),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: BlocBuilder<HomeworkBloc, HomeworkState>(
            builder: (context, state) {
              if (state is HomeworkLoading) {
                return _buildLoadingState(theme, isDark);
              } else if (state is HomeworkLoaded) {
                return _buildHomeworkGrid(state.homeworkList, theme, isDark);
              } else if (state is HomeworkFailure) {
                return _buildErrorState(state.message, theme, isDark);
              }
              return _buildEmptyState(theme, isDark);
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme, bool isDark) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: ModernEffects.modernGradient(
            isDark: isDark,
            type: GradientType.primary,
          ),
        ),
      ),
      title: Text(
        AppStrings.homeWork,
        style: TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
          fontSize: 22,
          letterSpacing: 0.5,
        ),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        Container(
          margin: const EdgeInsetsDirectional.only(end: 16.0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                context.read<HomeworkBloc>().add(GetHomeworksEvent());
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.refresh_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(ThemeData theme, bool isDark) {
    return Center(
      child: ModernEffects.glassmorphism(
        isDark: isDark,
        opacity: 0.9,
        blur: 15.0,
        borderRadius: BorderRadius.circular(24),
        margin: const EdgeInsets.all(40),
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: ModernEffects.modernGradient(
                  isDark: isDark,
                  type: GradientType.primary,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: ModernEffects.modernShadow(
                  isDark: isDark,
                  type: ShadowType.glow,
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 4,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'جاري تحميل الواجبات...',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 20,
                color: isDark ? AppColors.darkPrimaryText : AppColors.gray800,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'يرجى الانتظار قليلاً',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message, ThemeData theme, bool isDark) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (isDark ? AppColors.darkDestructive : AppColors.error).withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: isDark ? AppColors.darkDivider.withOpacity(0.3) : AppColors.gray200,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: (isDark ? AppColors.darkDestructive : AppColors.error).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: isDark ? AppColors.darkDestructive : AppColors.error,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'حدث خطأ في التحميل',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkPrimaryText : AppColors.gray800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<HomeworkBloc>().add(GetHomeworksEvent());
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('إعادة المحاولة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? AppColors.darkAccentBlue : AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeworkGrid(List<HomeworkEntity> homeworks, ThemeData theme, bool isDark) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeworkBloc>().add(GetHomeworksEvent());
      },
      color: theme.colorScheme.primary,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: ModernEffects.glassmorphism(
              isDark: isDark,
              opacity: 0.95,
              blur: 20.0,
              borderRadius: BorderRadius.circular(24),
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              child: Container(
                decoration: BoxDecoration(
                  gradient: ModernEffects.modernGradient(
                    isDark: isDark,
                    type: GradientType.primary,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: ModernEffects.modernShadow(
                    isDark: isDark,
                    type: ShadowType.glow,
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.assignment_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'الواجبات المتاحة',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${homeworks.length} واجب متاح',
                              style: TextStyle(
                                color: AppColors.white.withOpacity(0.9),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final homework = homeworks[index];
                  return _buildHomeworkCard(homework, index, theme, isDark);
                },
                childCount: homeworks.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeworkCard(HomeworkEntity homework, int index, ThemeData theme, bool isDark) {
    return AnimatedBuilder(
      animation: _fadeController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _fadeController.value)),
          child: Opacity(
            opacity: _fadeController.value,
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBackground : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _getSubjectColor(index).withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: isDark ? AppColors.darkDivider.withOpacity(0.3) : AppColors.gray200,
                  width: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  splashColor: _getSubjectColor(index).withOpacity(0.1),
                  highlightColor: _getSubjectColor(index).withOpacity(0.05),
                  onTap: () {
                    final int? homeworkId = int.tryParse(homework.id);
                    if (homeworkId != null) {
                      context.goToQuestions(homework.id);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('خطأ في معرف الواجب'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(homework.status).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _getStatusText(homework.status),
                                  style: TextStyle(
                                    color: _getStatusColor(homework.status),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: _getSubjectColor(index).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                _getSubjectIcon(homework.subject),
                                color: _getSubjectColor(index),
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                homework.subject,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.darkPrimaryText : AppColors.gray800,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: isDark ? AppColors.darkSecondaryText : AppColors.gray500,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                _formatDate(homework.dueDate),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? AppColors.darkSecondaryText : AppColors.gray500,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 36,
                          child: ElevatedButton(
                            onPressed: () {
                              final int? homeworkId = int.tryParse(homework.id);
                              if (homeworkId != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OneHomeworkPage(
                                      questionId: homeworkId,
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('خطأ في معرف الواجب'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _getSubjectColor(index),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'بدء الواجب',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isDark) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: isDark ? AppColors.darkDivider.withOpacity(0.3) : AppColors.gray200,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: (isDark ? AppColors.darkAccentBlue : AppColors.primary).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.assignment_outlined,
                size: 50,
                color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'لا توجد واجبات متاحة',
              style: TextStyle(
                fontSize: 22,
                color: isDark ? AppColors.darkPrimaryText : AppColors.gray800,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'تحقق لاحقاً من وجود واجبات جديدة',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'تم التسليم':
        return const Color(0xFF10B981);
      case 'pending':
      case 'قيد الانتظار':
        return const Color(0xFFF59E0B);
      case 'overdue':
      case 'متأخر':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'تم التسليم':
        return 'تم التسليم';
      case 'pending':
      case 'قيد الانتظار':
        return 'قيد الانتظار';
      case 'overdue':
      case 'متأخر':
        return 'متأخر';
      default:
        return 'غير محدد';
    }
  }

  Color _getSubjectColor(int index) {
    final colors = [
      const Color(0xFF4F46E5),
      const Color(0xFF7C3AED),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFF06B6D4),
    ];
    return colors[index % colors.length];
  }

  IconData _getSubjectIcon(String subject) {
    final subjectLower = subject.toLowerCase();
    if (subjectLower.contains('رياضيات') || subjectLower.contains('math')) {
      return Icons.calculate;
    } else if (subjectLower.contains('علوم') || subjectLower.contains('science')) {
      return Icons.science;
    } else if (subjectLower.contains('لغة') || subjectLower.contains('language')) {
      return Icons.language;
    } else if (subjectLower.contains('تاريخ') || subjectLower.contains('history')) {
      return Icons.history_edu;
    } else if (subjectLower.contains('جغرافيا') || subjectLower.contains('geography')) {
      return Icons.public;
    } else if (subjectLower.contains('حاسوب') || subjectLower.contains('computer')) {
      return Icons.computer;
    } else {
      return Icons.book;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference < 0) {
      return 'متأخر';
    } else if (difference == 0) {
      return 'اليوم';
    } else if (difference == 1) {
      return 'غداً';
    } else if (difference <= 7) {
      return 'خلال $difference أيام';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}