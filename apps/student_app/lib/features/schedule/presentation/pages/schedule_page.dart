import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:core/theme/index.dart';
import '../../../../widgets/responsive/responsive_widgets.dart';
import '../../../../widgets/shared_bottom_navigation.dart';
import '../blocs/schedule_bloc.dart';
import '../blocs/schedule_event.dart';
import '../blocs/schedule_state.dart';
import '../widgets/animated_schedule_list.dart';
import '../widgets/week_picker_widget.dart';

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

  @override
  void initState() {
    super.initState();
    _pageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pageAnimationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _pageAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _pageAnimationController.forward();

    // Load initial schedule for today
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🔍 SchedulePage: Loading initial schedule for date: $_selectedDate');
      context.read<ScheduleBloc>().add(LoadScheduleForDate(_selectedDate));
    });
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
            child: BlocBuilder<ScheduleBloc, ScheduleState>(
              builder: (context, state) {
                DateTime displayDate = _selectedDate;
                if (state is ScheduleLoaded) {
                  displayDate = state.selectedDate;
                }
                return Column(
                  children: [
                    WeekPicker(
                      selectedDate: displayDate,
                      onDateSelected: _onDateSelected,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          ' ${DateFormat('d MMMM yyyy', 'ar').format(displayDate)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: AnimatedScheduleList(
                        selectedDate: displayDate,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: SharedBottomNavigation(
        currentIndex: 2,
        onTap: (int index) {},
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      title: Text(
        'جدول الأسبوع',
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.white : AppColors.gray900,
        ),
      ),
      automaticallyImplyLeading: false,
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      elevation: 0,
      centerTitle: true,
    );
  }

  void _onDateSelected(DateTime date) {
    print('🔍 SchedulePage: Date selected: $date');
    setState(() {
      _selectedDate = date;
    });
    context.read<ScheduleBloc>().add(LoadScheduleForDate(date));
  }
}
