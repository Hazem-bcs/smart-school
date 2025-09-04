import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_text_styles.dart';
import 'package:core/theme/constants/app_spacing.dart';
import 'package:easy_localization/easy_localization.dart';
import '../blocs/attendance_details_bloc.dart';
import '../widgets/attendance_calendar_widget.dart';

class AttendanceDetailsPage extends StatefulWidget {
  final int month;
  final int year;

  const AttendanceDetailsPage({
    super.key,
    required this.month,
    required this.year,
  });

  @override
  State<AttendanceDetailsPage> createState() => _AttendanceDetailsPageState();
}

class _AttendanceDetailsPageState extends State<AttendanceDetailsPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    context.read<AttendanceDetailsBloc>().add(LoadAttendanceDetailsEvent(year: widget.year, month: widget.month));
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
    final isRtl = context.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(brightness),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.calendar_month,
                color: AppColors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'attendance_details'.tr(),
              style: AppTextStyles.h2.copyWith(
                color: AppColors.white,
                fontWeight: AppTextStyles.bold,
                shadows: [
                  Shadow(
                    color: AppColors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.8),
                AppColors.secondary,
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ),
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.white.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.white,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.white.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                context.read<AttendanceDetailsBloc>().add(LoadAttendanceDetailsEvent(year: widget.year, month: widget.month));
              },
              icon: const Icon(
                Icons.refresh_rounded,
                color: AppColors.white,
                size: 20,
              ),
            ),
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: BlocBuilder<AttendanceDetailsBloc, AttendanceDetailsState>(
            builder: (context, state) {
              if (state is AttendanceDetailsLoading) {
                return _buildLoadingState();
              } else if (state is AttendanceDetailsLoaded) {
                return _buildContent(state, isRtl);
              } else if (state is AttendanceDetailsError) {
                return _buildErrorState(state.message);
              }
              return _buildInitialState();
            },
          ),
        ),
      ),
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
            'loading_attendance_details'.tr(),
            style: const TextStyle(color: AppColors.gray500),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<AttendanceDetailsBloc>().add(LoadAttendanceDetailsEvent(year: widget.year, month: widget.month));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
          child: Center(
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
                  'error_loading_details'.tr(),
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.error,
                    fontWeight: AppTextStyles.medium,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.xl),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<AttendanceDetailsBloc>().add(
                      LoadAttendanceDetailsEvent(year: widget.year, month: widget.month),
                    );
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
          ),
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.calendar_today,
            size: 60,
            color: AppColors.gray400,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'loading_attendance_details'.tr(),
            style: const TextStyle(color: AppColors.gray500),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(AttendanceDetailsLoaded state, bool isRtl) {
    final List<int> presentDays = state.attendanceDetails.presentDays;
    final List<int> absentDays = state.attendanceDetails.absentDays;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<AttendanceDetailsBloc>().add(LoadAttendanceDetailsEvent(year: widget.year, month: widget.month));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isRtl),
            SizedBox(height: AppSpacing.xl),
            _buildStatistics(presentDays, absentDays),
            SizedBox(height: AppSpacing.xl),
            _buildProgressSection(presentDays, absentDays),
            SizedBox(height: AppSpacing.xl),
            AttendanceCalendarWidget(
              presentDays: presentDays,
              absentDays: absentDays,
              year: widget.year,
              month: widget.month,
              isRtl: isRtl,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isRtl) {
    return Container(
      padding: AppSpacing.lgPadding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: AppSpacing.mdPadding,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.calendar_month,
              color: AppColors.white,
              size: 24,
            ),
          ),
          SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${getMonthName(widget.month, isRtl)} ${widget.year}',
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.white,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'attendance_overview'.tr(),
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics(List<int> presentDays, List<int> absentDays) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.check_circle,
            title: 'present'.tr(),
            value: presentDays.length.toString(),
            color: AppColors.success,
            gradient: LinearGradient(
              colors: [AppColors.success, AppColors.success.withOpacity(0.7)],
            ),
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildStatCard(
            icon: Icons.cancel,
            title: 'absent'.tr(),
            value: absentDays.length.toString(),
            color: AppColors.error,
            gradient: LinearGradient(
              colors: [AppColors.error, AppColors.error.withOpacity(0.7)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Gradient gradient,
  }) {
    return Container(
      padding: AppSpacing.lgPadding,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.white,
            size: 28,
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: AppTextStyles.h1.copyWith(
              color: AppColors.white,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.white.withOpacity(0.9),
              fontWeight: AppTextStyles.medium,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(List<int> presentDays, List<int> absentDays) {
    final brightness = Theme.of(context).brightness;
    final totalDays = presentDays.length + absentDays.length;
    final attendanceRate = totalDays > 0 ? (presentDays.length / totalDays) : 0.0;

    return Container(
      padding: AppSpacing.lgPadding,
      decoration: BoxDecoration(
        color: AppColors.getSurfaceColor(brightness),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'attendance_rate'.tr(),
            style: AppTextStyles.h3.copyWith(
              color: AppColors.getPrimaryTextColor(brightness),
              fontWeight: AppTextStyles.bold,
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${(attendanceRate * 100).toStringAsFixed(1)}%',
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.success,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      'attendance_percentage'.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.getSecondaryTextColor(brightness),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$totalDays',
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.getPrimaryTextColor(brightness),
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      'total_days'.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.getSecondaryTextColor(brightness),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          LinearProgressIndicator(
            value: attendanceRate,
            backgroundColor: AppColors.gray200,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  String getMonthName(int month, bool isRtl) {
    switch (month) {
      case DateTime.january:
        return isRtl ? 'كانون الثاني' : 'January';
      case DateTime.february:
        return isRtl ? 'شباط' : 'February';
      case DateTime.march:
        return isRtl ? 'آذار' : 'March';
      case DateTime.april:
        return isRtl ? 'نيسان' : 'April';
      case DateTime.may:
        return isRtl ? 'أيار' : 'May';
      case DateTime.june:
        return isRtl ? 'حزيران' : 'June';
      case DateTime.july:
        return isRtl ? 'تموز' : 'July';
      case DateTime.august:
        return isRtl ? 'آب' : 'August';
      case DateTime.september:
        return isRtl ? 'أيلول' : 'September';
      case DateTime.october:
        return isRtl ? 'تشرين الأول' : 'October';
      case DateTime.november:
        return isRtl ? 'تشرين الثاني' : 'November';
      case DateTime.december:
        return isRtl ? 'كانون الاول' : 'December';
      default:
        return '';
    }
  }
}