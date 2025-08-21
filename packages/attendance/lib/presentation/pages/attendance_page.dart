import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_text_styles.dart';
import 'package:core/theme/constants/app_spacing.dart';
import 'package:easy_localization/easy_localization.dart';
import '../blocs/attendance_bloc.dart';
import '../blocs/attendance_details_bloc.dart';
import 'package:get_it/get_it.dart';
import '../widgets/attendance_summary_card.dart';
import 'attendance_details_page.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage>
    with TickerProviderStateMixin {
  final int _currentYear = 2025;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    context.read<AttendanceBloc>().add(LoadMonthlyAttendance(_currentYear));
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(brightness),
      appBar: AppBar(
        title: Text(
          'lbl_attendance'.tr(),
          style: AppTextStyles.h2.copyWith(
            color: AppColors.white,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildAttendanceList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.secondary,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Container(
                    padding: AppSpacing.mdPadding,
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.calendar_today,
                      color: AppColors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'attendance_summary'.tr(),
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.white,
                            fontWeight: AppTextStyles.medium,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          '$_currentYear',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xl),
              _buildSummaryCards(),
              SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return BlocBuilder<AttendanceBloc, AttendanceState>(
      builder: (context, state) {
        int totalPresent = 0;
        int totalAbsent = 0;

        if (state is MonthlyAttendanceLoaded) {
          for (var month in state.monthlyAttendance) {
            totalPresent += month.attendanceCount;
            totalAbsent += month.absenceCount;
          }
        }

        return Row(
          children: [
            Expanded(
              child: AttendanceSummaryCard(
                icon: Icons.check_circle,
                title: 'total_present'.tr(),
                value: totalPresent.toString(),
                color: AppColors.success,
                gradient: LinearGradient(
                  colors: [AppColors.success, AppColors.success.withOpacity(0.7)],
                ),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: AttendanceSummaryCard(
                icon: Icons.cancel,
                title: 'total_absent'.tr(),
                value: totalAbsent.toString(),
                color: AppColors.error,
                gradient: LinearGradient(
                  colors: [AppColors.error, AppColors.error.withOpacity(0.7)],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAttendanceList() {
    return BlocBuilder<AttendanceBloc, AttendanceState>(
      builder: (context, state) {
        if (state is AttendanceLoading) {
          return _buildLoadingState();
        } else if (state is MonthlyAttendanceLoaded) {
          if (state.monthlyAttendance.isEmpty) {
            return _buildEmptyState();
          }
          return _buildAttendanceListView(state.monthlyAttendance);
        } else if (state is AttendanceError) {
          return _buildErrorState(state.message);
        }
        return _buildInitialState();
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'loading_attendance'.tr(),
            style: const TextStyle(color: AppColors.gray500),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: AppSpacing.xlPadding,
            decoration: BoxDecoration(
              color: AppColors.gray100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calendar_month_outlined,
              size: 60,
              color: AppColors.gray400,
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'no_attendance_data'.tr(),
            style: AppTextStyles.h3.copyWith(
              color: AppColors.gray500,
              fontWeight: AppTextStyles.medium,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: AppSpacing.xlPadding,
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              size: 60,
              color: AppColors.error,
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'error_loading_data'.tr(),
            style: AppTextStyles.h3.copyWith(
              color: AppColors.error,
              fontWeight: AppTextStyles.medium,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.xl),
          ElevatedButton.icon(
            onPressed: () {
              context.read<AttendanceBloc>().add(LoadMonthlyAttendance(_currentYear));
            },
            icon: const Icon(Icons.refresh),
            label: Text('retry'.tr()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.touch_app,
            size: 60,
            color: AppColors.gray400,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'tap_to_load_attendance'.tr(),
            style: const TextStyle(color: AppColors.gray500),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceListView(List<dynamic> monthlyAttendance) {
    return ListView.builder(
      padding: AppSpacing.screenPadding,
      itemCount: monthlyAttendance.length,
      itemBuilder: (context, index) {
        final monthData = monthlyAttendance[index];
        
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Text(
                _getMonthShortName(monthData.monthName),
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(monthData.monthName),
            subtitle: Text('Present: ${monthData.attendanceCount} | Absent: ${monthData.absenceCount}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => GetIt.instance<AttendanceDetailsBloc>(),
                    child: AttendanceDetailsPage(
                      year: _currentYear,
                      month: monthData.monthNumber,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _getMonthShortName(String fullName) {
    switch (fullName) {
      case 'January':
        return 'Jan';
      case 'February':
        return 'Feb';
      case 'March':
        return 'Mar';
      case 'April':
        return 'Apr';
      case 'May':
        return 'May';
      case 'June':
        return 'Jun';
      case 'July':
        return 'Jul';
      case 'August':
        return 'Aug';
      case 'September':
        return 'Sep';
      case 'October':
        return 'Oct';
      case 'November':
        return 'Nov';
      case 'December':
        return 'Dec';
      default:
        return fullName.length > 3 ? fullName.substring(0, 3) : fullName;
    }
  }
}

