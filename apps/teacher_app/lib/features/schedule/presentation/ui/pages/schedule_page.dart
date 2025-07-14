import 'package:flutter/material.dart';
import '../../../../../core/responsive_widgets.dart';
import '../../../../../widgets/shared_bottom_navigation.dart';
import '../../../../../routing/navigation_extension.dart';
import '../../../../home/presentation/ui/pages/home_page.dart';
import '../../../../assignment/presentation/ui/pages/assignments_page.dart';
import '../widgets/custom_calendar.dart';
import '../widgets/animated_schedule_list.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>
    with TickerProviderStateMixin {
  late AnimationController _pageAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();

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
  }

  @override
  void dispose() {
    _pageAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ResponsiveContent(
            child: Column(
              children: [
                CustomCalendar(
                  currentMonth: _currentMonth,
                  selectedDate: _selectedDate,
                  onDateSelected: _onDateSelected,
                  onMonthChanged: _onMonthChanged,
                ),
                Expanded(
                  child: AnimatedScheduleList(
                    selectedDate: _selectedDate,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SharedBottomNavigation(
        currentIndex: 2, // Schedule index (replacing Students)
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    
    return AppBar(
      title: Text(
        'Weekly Schedule',
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : const Color(0xFF0E141B),
        ),
      ),
      automaticallyImplyLeading: false,
      backgroundColor: isDark 
          ? const Color(0xFF1A1A2E) 
          : const Color(0xFFF8F9FA),
      elevation: 0,
      centerTitle: true,
    );
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _onMonthChanged(DateTime newMonth) {
    setState(() {
      _currentMonth = newMonth;
    });
  }
} 