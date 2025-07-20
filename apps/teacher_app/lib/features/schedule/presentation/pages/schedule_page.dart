import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/responsive/responsive_widgets.dart';
import '../../../../core/widgets/shared_bottom_navigation.dart';
import '../blocs/schedule_bloc.dart';
import '../blocs/schedule_event.dart';
import '../blocs/schedule_state.dart';
import '../widgets/index.dart';

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
    _initializeAnimations();
    _loadInitialData();
  }

  void _initializeAnimations() {
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
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
      appBar: ScheduleAppBar(onRefresh: _onRefresh),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ResponsiveContent(
            child: BlocListener<ScheduleBloc, ScheduleState>(
              listener: (context, state) {
                if (state is ScheduleError) {
                  ScheduleSnackBarHelper.showErrorMessage(context, state.message);
                }
              },
              child: BlocBuilder<ScheduleBloc, ScheduleState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      WeekPicker(
                        selectedDate: _selectedDate,
                        onDateSelected: _onDateSelected,
                      ),
                      ScheduleDateHeader(selectedDate: _selectedDate),
                      Expanded(
                        child: ScheduleRefreshWrapper(
                          onRefresh: _onRefresh,
                          child: _buildScheduleContent(state),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const SharedBottomNavigation(currentIndex: 2),
    );
  }

  Widget _buildScheduleContent(ScheduleState state) {
    if (state is ScheduleLoading) {
      return const ScheduleLoadingWidget();
    } else if (state is ScheduleLoaded) {
      return AnimatedScheduleList(
        selectedDate: _selectedDate,
        schedules: state.schedules,
      );
    } else if (state is ScheduleError) {
      return ScheduleErrorWidget(
        message: state.message,
        onRetry: _onRefresh,
      );
    } else {
      return const ScheduleEmptyWidget();
    }
  }

  Future<void> _onRefresh() async {
    ScheduleSnackBarHelper.showRefreshMessage(context);
    
    context.read<ScheduleBloc>().add(LoadScheduleForDate(_selectedDate));
    
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (mounted) {
      ScheduleSnackBarHelper.showSuccessMessage(context);
    }
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    context.read<ScheduleBloc>().add(LoadScheduleForDate(date));
  }
}
