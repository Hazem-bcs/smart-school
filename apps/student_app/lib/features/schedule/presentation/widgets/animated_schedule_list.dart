import 'package:flutter/material.dart';

import '../../../../widgets/responsive/responsive_helper.dart';
import '../../domain/entities/schedule_entity.dart';
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
    // Sample schedule data based on selected date
    final selectedDate = widget.selectedDate;
    final dayOfWeek = selectedDate.weekday;
    final _ = selectedDate.day;
    
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
            'id': 'lit101',
            'icon': Icons.book,
            'title': 'الأدب',
            'subtitle': '11:00 AM - 12:00 PM',
            'status': ScheduleStatus.upcoming,
          },
          {
            'id': 'comp111',
            'icon': Icons.computer,
            'title': 'الحاسوب',
            'subtitle': '2:00 PM - 3:00 PM',
            'status': ScheduleStatus.completed,
          },
        ];
      case 5: // Friday
        return [
          {
            'id': 'rel112',
            'icon': Icons.book,
            'title': 'التربية الإسلامية',
            'subtitle': '8:00 AM - 9:00 AM',
            'status': ScheduleStatus.completed,
          },
          {
            'id': 'sport113',
            'icon': Icons.sports_soccer,
            'title': 'التربية البدنية',
            'subtitle': '10:00 AM - 11:00 AM',
            'status': ScheduleStatus.upcoming,
          },
          {
            'id': 'music114',
            'icon': Icons.music_note,
            'title': 'الموسيقى',
            'subtitle': '1:00 PM - 2:00 PM',
            'status': ScheduleStatus.upcoming,
          },
        ];
      default: // Weekend (Saturday/Sunday)
        return [
          {
            'id': 'weekend',
            'icon': Icons.weekend,
            'title': 'عطلة نهاية الأسبوع',
            'subtitle': 'لا توجد دروس اليوم',
            'status': ScheduleStatus.completed,
          },
        ];
    }
  }

  String _getDateString() {
    final selectedDate = widget.selectedDate;
    const days = ['الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    
    final dayName = days[selectedDate.weekday - 1];
    final monthName = months[selectedDate.month - 1];
    final dayNumber = selectedDate.day;
    final year = selectedDate.year;
    
    return '$dayName، $dayNumber $monthName $year';
  }

  void _onScheduleItemTap(Map<String, dynamic> item) {
    // TODO: Navigate to schedule item details
    print('Schedule item tapped: ${item['title']}');
  }
} 