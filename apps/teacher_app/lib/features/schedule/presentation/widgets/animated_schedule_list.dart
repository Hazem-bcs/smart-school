import 'package:flutter/material.dart';
import 'package:teacher_app/features/schedule/domain/entities/schedule_entity.dart';
import '../../../../core/responsive/responsive_helper.dart';
import 'schedule_card.dart';

class AnimatedScheduleList extends StatefulWidget {
  final DateTime selectedDate;
  final List<ScheduleEntity> schedules;

  const AnimatedScheduleList({
    super.key,
    required this.selectedDate,
    required this.schedules,
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
    if (oldWidget.selectedDate != widget.selectedDate || 
        oldWidget.schedules != widget.schedules) {
      // Reinitialize animations when date or schedules change
      _initializeAnimations();
    }
  }

  void _initializeAnimations() {
    final scheduleItems = _getScheduleItems();
    _animationControllers = List.generate(
      scheduleItems.length,
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
    final scheduleItems = _getScheduleItems();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bool isFullHoliday = scheduleItems.isNotEmpty &&
        scheduleItems.every((item) => (item['title'] as String).startsWith('عطلة'));
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context),
            vertical: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
          ),
          child: isFullHoliday
              ? Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF14532D) : const Color(0xFFD1FAE5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.celebration, color: isDark ? const Color(0xFF34D399) : const Color(0xFF10B981), size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'عطلة: ${_getDateString()}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF065F46),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Text(
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
            child: scheduleItems.isEmpty 
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 64,
                          color: isDark ? Colors.white54 : Colors.grey[400],
                        ),
                        SizedBox(height: ResponsiveHelper.getSpacing(context)),
                        Text(
                          'لا توجد دروس لهذا اليوم',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: isDark ? Colors.white54 : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'اسحب للأسفل للتحديث',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark ? Colors.white38 : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : isFullHoliday
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.celebration, size: 80, color: isDark ? const Color(0xFF34D399) : const Color(0xFF10B981)),
                            const SizedBox(height: 12),
                            Text(
                              'عطلة يوم كامل',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF065F46),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'لا توجد حصص أو مهام مجدولة لهذا اليوم',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isDark ? Colors.white70 : const Color(0xFF065F46),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                    itemCount: scheduleItems.length,
                    itemBuilder: (context, index) {
                      final item = scheduleItems[index];
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
                                  id: item['id'] as String,
                                  icon: item['icon'] as IconData,
                                  title: item['title'] as String,
                                  subtitle: item['subtitle'] as String,
                                  status: item['status'] as ScheduleStatus,
                                  onTap: () => _onScheduleItemTap(item),
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
  }

  List<Map<String, dynamic>> _getScheduleItems() {
    // إذا كانت هناك بيانات من Bloc، استخدمها
    if (widget.schedules.isNotEmpty) {
      return widget.schedules.map((schedule) {
        if (schedule.type == ScheduleType.holiday) {
          return {
            'id': schedule.id,
            'icon': Icons.celebration,
            'title': 'عطلة: ${_getDateString()}',
            'subtitle': 'لا توجد حصص اليوم',
            'status': schedule.status,
            'schedule': schedule,
          };
        }
        return {
          'id': schedule.id,
          'icon': _getIconForSubject(schedule.subject),
          'title': schedule.title,
          'subtitle': '${_formatTime(schedule.startTime)} - ${_formatTime(schedule.endTime)}',
          'status': schedule.status,
          'schedule': schedule,
        };
      }).toList();
    }

    // إذا لم تكن هناك بيانات، استخدم البيانات الوهمية
    final selectedDate = widget.selectedDate;
    final dayOfWeek = selectedDate.weekday;
    
    // Different schedules for different days
    switch (dayOfWeek) {
      case 1: // Monday
        return [
          {
            'id': 'math101',
            'icon': Icons.book,
            'title': 'الرياضيات',
            'subtitle': '9:00 AM - 10:00 AM',
            'status': ScheduleStatus.upcoming,
          },
          {
            'id': 'sci202',
            'icon': Icons.science,
            'title': 'العلوم',
            'subtitle': '10:30 AM - 11:30 AM',
            'status': ScheduleStatus.upcoming,
          },
          {
            'id': 'eng404',
            'icon': Icons.edit,
            'title': 'اللغة الإنجليزية',
            'subtitle': '2:30 PM - 3:30 PM',
            'status': ScheduleStatus.completed,
          },
        ];
      case 2: // Tuesday
        return [
          {
            'id': 'his303',
            'icon': Icons.history_edu,
            'title': 'التاريخ',
            'subtitle': '9:00 AM - 10:00 AM',
            'status': ScheduleStatus.upcoming,
          },
          {
            'id': 'geo505',
            'icon': Icons.public,
            'title': 'الجغرافيا',
            'subtitle': '11:00 AM - 12:00 PM',
            'status': ScheduleStatus.upcoming,
          },
          {
            'id': 'art606',
            'icon': Icons.palette,
            'title': 'الفنون',
            'subtitle': '2:00 PM - 3:00 PM',
            'status': ScheduleStatus.upcoming,
          },
        ];
      case 3: // Wednesday
        return [
          {
            'id': 'math101',
            'icon': Icons.book,
            'title': 'الرياضيات',
            'subtitle': '8:30 AM - 9:30 AM',
            'status': ScheduleStatus.completed,
          },
          {
            'id': 'phy707',
            'icon': Icons.science,
            'title': 'الفيزياء',
            'subtitle': '10:00 AM - 11:00 AM',
            'status': ScheduleStatus.upcoming,
          },
          {
            'id': 'chem808',
            'icon': Icons.science,
            'title': 'الكيمياء',
            'subtitle': '1:30 PM - 2:30 PM',
            'status': ScheduleStatus.upcoming,
          },
        ];
      case 4: // Thursday
        return [
          {
            'id': 'bio909',
            'icon': Icons.science,
            'title': 'الأحياء',
            'subtitle': '9:00 AM - 10:00 AM',
            'status': ScheduleStatus.upcoming,
          },
          {
            'id': 'comp1010',
            'icon': Icons.computer,
            'title': 'الحاسوب',
            'subtitle': '11:00 AM - 12:00 PM',
            'status': ScheduleStatus.upcoming,
          },
        ];
      case 5: // Friday
        return [
          {
            'id': 'rel1111',
            'icon': Icons.menu_book,
            'title': 'التربية الإسلامية',
            'subtitle': '9:00 AM - 10:00 AM',
            'status': ScheduleStatus.upcoming,
          },
          {
            'id': 'arab1212',
            'icon': Icons.edit,
            'title': 'اللغة العربية',
            'subtitle': '10:30 AM - 11:30 AM',
            'status': ScheduleStatus.upcoming,
          },
        ];
      default: // Weekend
        return [];
    }
  }

  IconData _getIconForSubject(String subject) {
    switch (subject.toLowerCase()) {
      case 'الرياضيات':
      case 'mathematics':
      case 'math':
        return Icons.book;
      case 'العلوم':
      case 'science':
        return Icons.science;
      case 'الفيزياء':
      case 'physics':
        return Icons.science;
      case 'الكيمياء':
      case 'chemistry':
        return Icons.science;
      case 'الأحياء':
      case 'biology':
        return Icons.science;
      case 'التاريخ':
      case 'history':
        return Icons.history_edu;
      case 'الجغرافيا':
      case 'geography':
        return Icons.public;
      case 'اللغة العربية':
      case 'arabic':
        return Icons.edit;
      case 'اللغة الإنجليزية':
      case 'english':
        return Icons.edit;
      case 'التربية الإسلامية':
      case 'islamic':
        return Icons.menu_book;
      case 'الفنون':
      case 'art':
        return Icons.palette;
      case 'الحاسوب':
      case 'computer':
        return Icons.computer;
      default:
        return Icons.school;
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  String _getDateString() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(widget.selectedDate.year, widget.selectedDate.month, widget.selectedDate.day);
    
    if (selected == today) {
      return 'اليوم';
    } else if (selected == today.add(const Duration(days: 1))) {
      return 'غداً';
    } else if (selected == today.subtract(const Duration(days: 1))) {
      return 'أمس';
    } else {
      // تنسيق التاريخ باللغة العربية
      // Dart: weekday => 1=Monday ... 7=Sunday
      final days = ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
      final months = [
        'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
        'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
      ];
      
      return '${days[widget.selectedDate.weekday - 1]}، ${widget.selectedDate.day} ${months[widget.selectedDate.month - 1]}';
    }
  }

  void _onScheduleItemTap(Map<String, dynamic> item) {
    // يمكن إضافة منطق إضافي هنا عند النقر على عنصر الجدول
    print('Tapped on schedule item: ${item['title']}');
  }
} 