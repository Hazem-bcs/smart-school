import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:core/theme/index.dart';
import 'package:core/widgets/index.dart';

import '../../../../widgets/responsive/responsive_helper.dart';
import '../../domain/entities/schedule_entity.dart';
import '../blocs/schedule_bloc.dart';
import '../blocs/schedule_state.dart';
import 'schedule_card.dart';

class AnimatedScheduleList extends StatefulWidget {
  final DateTime selectedDate;

  const AnimatedScheduleList({
    super.key,
    required this.selectedDate,
  });

  @override
  State<AnimatedScheduleList> createState() => _AnimatedScheduleListState();
}

class _AnimatedScheduleListState extends State<AnimatedScheduleList>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void didUpdateWidget(AnimatedScheduleList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      // Reinitialize animations when date changes
      _initializeAnimations();
    }
  }

  void _initializeAnimations() {
    // Initialize with a default number, will be updated when data is available
    final initialCount = 1; // Changed from 3 to 1 to avoid issues
    _animationControllers = List.generate(
      initialCount,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      ),
    );

    _fadeAnimations = _animationControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
    }).toList();

    _slideAnimations = _animationControllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutCubic,
      ));
    }).toList();
  }

  void _updateAnimations(int count) {
    // Dispose old controllers
    for (final controller in _animationControllers) {
      controller.dispose();
    }

    // Ensure we have at least 1 controller
    final actualCount = count > 0 ? count : 1;
    
    // Create new controllers
    _animationControllers = List.generate(
      actualCount,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      ),
    );

    _fadeAnimations = _animationControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
    }).toList();

    _slideAnimations = _animationControllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutCubic,
      ));
    }).toList();

    // Start animations immediately after creating them
    _startStaggeredAnimation();
  }

  void _startStaggeredAnimation() {
    for (int i = 0; i < _animationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          _animationControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        print('🔍 AnimatedScheduleList: Current state: ${state.runtimeType}');
        
        if (state is ScheduleLoaded) {
          print('🔍 AnimatedScheduleList: Loaded ${state.schedules.length} schedules');
          print('🔍 AnimatedScheduleList: Schedules: ${state.schedules.map((s) => s.title).toList()}');
          
          // Update animations when data changes
          if (_animationControllers.length != state.schedules.length) {
            print('🔍 AnimatedScheduleList: Updating animations from ${_animationControllers.length} to ${state.schedules.length}');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _updateAnimations(state.schedules.length);
            });
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date header
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getSpacing(context),
                  vertical: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
                ),
                child: Text(
                  _getDateString(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0E141B),
                  ),
                ),
              ),
              // Schedule list
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.getSpacing(context),
                    vertical: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
                  ),
                  child: state.schedules.isEmpty 
                      ? Center(
                                            child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 64,
                        color: isDark ? AppColors.darkSecondaryText : AppColors.gray400,
                      ),
                      SizedBox(height: ResponsiveHelper.getSpacing(context)),
                      Text(
                        'لا توجد دروس لهذا اليوم',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
                        ),
                      ),
                    ],
                  ),
                        )
                      : ListView.builder(
                          itemCount: state.schedules.length,
                          itemBuilder: (context, index) {
                            // Safety check
                            if (index >= state.schedules.length || index >= _animationControllers.length) {
                              return const SizedBox.shrink();
                            }
                            
                            final schedule = state.schedules[index];
                            return AnimatedBuilder(
                              animation: _animationControllers[index],
                              builder: (context, child) {
                                return FadeTransition(
                                  opacity: _fadeAnimations[index],
                                  child: SlideTransition(
                                    position: _slideAnimations[index],
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
                                      ),
                                      child: ScheduleCard(
                                        id: schedule.id,
                                        icon: _getIconForSubject(schedule.subject),
                                        title: schedule.title,
                                        subtitle: _formatTimeRange(schedule.startTime, schedule.endTime),
                                        status: schedule.status,
                                        onTap: () => _onScheduleItemTap(schedule),
                                      ),
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
        } else if (state is ScheduleLoading) {
          print('🔍 AnimatedScheduleList: Loading state');
          return const Center(
            child: SmartSchoolLoading(
              message: 'جاري تحميل الجدول...',
              type: LoadingType.primary,
            ),
          );
        } else if (state is ScheduleError) {
          print('🔍 AnimatedScheduleList: Error state: ${state.message}');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
                SizedBox(height: ResponsiveHelper.getSpacing(context)),
                Text(
                  'حدث خطأ في تحميل الجدول',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.error,
                  ),
                ),
                Text(
                  state.message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.error.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          );
        } else {
          print('🔍 AnimatedScheduleList: Initial state');
          return const Center(child: Text('جاري تحميل الجدول...'));
        }
      },
    );
  }

  IconData _getIconForSubject(String subject) {
    switch (subject.toLowerCase()) {
      case 'mathematics':
      case 'الرياضيات':
        return Icons.functions;
      case 'physics':
      case 'الفيزياء':
        return Icons.science;
      case 'chemistry':
      case 'الكيمياء':
        return Icons.science;
      case 'biology':
      case 'الأحياء':
        return Icons.science;
      case 'english':
      case 'اللغة الإنجليزية':
        return Icons.language;
      case 'arabic':
      case 'اللغة العربية':
        return Icons.edit;
      case 'history':
      case 'التاريخ':
        return Icons.history_edu;
      case 'geography':
      case 'الجغرافيا':
        return Icons.public;
      case 'art':
      case 'الفنون':
        return Icons.palette;
      case 'computer':
      case 'الحاسوب':
        return Icons.computer;
      case 'sports':
      case 'التربية البدنية':
        return Icons.sports_soccer;
      case 'music':
      case 'الموسيقى':
        return Icons.music_note;
      case 'religion':
      case 'التربية الإسلامية':
        return Icons.book;
      default:
        return Icons.book;
    }
  }

  String _formatTimeRange(DateTime startTime, DateTime endTime) {
    final startFormat = DateFormat('h:mm a');
    final endFormat = DateFormat('h:mm a');
    return '${startFormat.format(startTime)} - ${endFormat.format(endTime)}';
  }

  String _getDateString() {
    const days = ['الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    
    final dayName = days[widget.selectedDate.weekday - 1];
    final monthName = months[widget.selectedDate.month - 1];
    final dayNumber = widget.selectedDate.day;
    final year = widget.selectedDate.year;
    
    return '$dayName، $dayNumber $monthName $year';
  }

  void _onScheduleItemTap(ScheduleEntity schedule) {
    // TODO: Navigate to schedule item details
    print('Schedule item tapped: ${schedule.title}');
  }
} 