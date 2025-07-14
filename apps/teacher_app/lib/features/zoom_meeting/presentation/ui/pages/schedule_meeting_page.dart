import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/zoom_meeting_bloc.dart';
import '../../blocs/zoom_meeting_event.dart';
import '../../blocs/zoom_meeting_state.dart';
import '../../widgets/header_card.dart';
import '../../widgets/topic_card.dart';
import '../../widgets/classes_section.dart';
import '../../widgets/date_time_section.dart';
import '../../widgets/options_section.dart';
import '../../widgets/schedule_button.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/success_dialog.dart';

class ScheduleMeetingPage extends StatefulWidget {
  const ScheduleMeetingPage({super.key});

  @override
  State<ScheduleMeetingPage> createState() => _ScheduleMeetingPageState();
}

class _ScheduleMeetingPageState extends State<ScheduleMeetingPage>
    with TickerProviderStateMixin {
  final TextEditingController _topicController = TextEditingController();
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    context.read<ZoomMeetingBloc>().add(LoadInitialData());
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

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _topicController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E21) : const Color(0xFFF8FAFC),
      appBar: _buildAppBar(theme, isDark),
      body: BlocListener<ZoomMeetingBloc, ZoomMeetingState>(
        listener: (context, state) {
          if (state is ZoomMeetingScheduled) {
            _showSuccessDialog(context, state);
          } else if (state is ZoomMeetingError) {
            _showErrorSnackBar(context, state.message);
          }
        },
        child: BlocBuilder<ZoomMeetingBloc, ZoomMeetingState>(
          builder: (context, state) {
            if (state is ZoomMeetingLoading) {
              return _buildLoadingWidget(context, isDark);
            } else if (state is ZoomMeetingDataLoaded) {
              return _buildContent(context, state, isDark);
            } else if (state is ZoomMeetingError) {
              return ScheduleMeetingErrorWidget(message: state.message);
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme, bool isDark) {
    return AppBar(
      backgroundColor: isDark ? const Color(0xFF1A1F35) : Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2F45) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : const Color(0xFF475569),
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        'Schedule New Meeting',
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : const Color(0xFF1E293B),
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildLoadingWidget(BuildContext context, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1F35) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? const Color(0xFF6366F1) : const Color(0xFF5A67D8),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading...',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : const Color(0xFF64748B),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, ZoomMeetingDataLoaded state, bool isDark) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF0A0E21),
                      Color(0xFF1A1F35),
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFF8FAFC),
                      Color(0xFFF1F5F9),
                    ],
                  ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ScheduleMeetingHeaderCard(),
                const SizedBox(height: 32),
                
                TopicCard(
                  controller: _topicController,
                  topic: state.topic,
                ),
                const SizedBox(height: 32),
                
                ClassesSection(
                  availableClasses: state.availableClasses,
                  selectedClasses: state.selectedClasses,
                ),
                const SizedBox(height: 32),
                
                DateTimeSection(
                  selectedDate: state.selectedDate,
                  selectedTime: state.selectedTime,
                ),
                const SizedBox(height: 32),
                
                OptionsSection(
                  meetingOptions: state.meetingOptions,
                  optionStates: state.optionStates,
                ),
                const SizedBox(height: 40),
                
                const ScheduleButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, ZoomMeetingScheduled state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ScheduleMeetingSuccessDialog(state: state),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isDark ? const Color(0xFFDC2626) : const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
} 