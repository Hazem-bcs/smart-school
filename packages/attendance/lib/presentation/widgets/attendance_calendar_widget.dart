import 'package:flutter/material.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_text_styles.dart';
import 'package:core/theme/constants/app_spacing.dart';
import 'package:easy_localization/easy_localization.dart';

class AttendanceCalendarWidget extends StatelessWidget {
  final List<int> presentDays;
  final List<int> absentDays;
  final int year;
  final int month;
  final bool isRtl;

  const AttendanceCalendarWidget({
    super.key,
    required this.presentDays,
    required this.absentDays,
    required this.year,
    required this.month,
    required this.isRtl,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final daysInMonth = _getDaysInMonth(year, month);
    final firstDayOfWeek = _getFirstDayOfWeek(year, month);
    
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
          Row(
            children: [
              Icon(
                Icons.calendar_view_month,
                color: AppColors.primary,
                size: 24,
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                'daily_attendance'.tr(),
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.getPrimaryTextColor(brightness),
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          _buildLegend(),
          SizedBox(height: AppSpacing.lg),
          _buildCalendarGrid(daysInMonth, firstDayOfWeek, presentDays, absentDays, isRtl),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem(
          color: AppColors.success,
          icon: Icons.check_circle,
          label: 'present'.tr(),
        ),
        _buildLegendItem(
          color: AppColors.error,
          icon: Icons.cancel,
          label: 'absent'.tr(),
        ),
        _buildLegendItem(
          color: AppColors.gray300,
          icon: Icons.circle_outlined,
          label: 'no_data'.tr(),
        ),
      ],
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required IconData icon,
    required String label,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.white,
            size: 16,
          ),
        ),
        SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.gray600,
            fontWeight: AppTextStyles.medium,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid(
    int daysInMonth,
    int firstDayOfWeek,
    List<int> presentDays,
    List<int> absentDays,
    bool isRtl,
  ) {
    final weekDays = isRtl 
        ? ['أحد', 'اثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة', 'سبت']
        : ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Column(
      children: [
        // Week days header
        Row(
          children: weekDays.map((day) => Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text(
                day,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: AppTextStyles.medium,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )).toList(),
        ),
        SizedBox(height: AppSpacing.sm),
        // Calendar grid
        ...List.generate((daysInMonth + firstDayOfWeek - 1) ~/ 7 + 1, (weekIndex) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: List.generate(7, (dayIndex) {
                final dayNumber = weekIndex * 7 + dayIndex - firstDayOfWeek + 1;
                
                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return const Expanded(child: SizedBox());
                }

                final isPresent = presentDays.contains(dayNumber);
                final isAbsent = absentDays.contains(dayNumber);
                
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getDayColor(isPresent, isAbsent),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.gray200,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dayNumber.toString(),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: _getDayTextColor(isPresent, isAbsent),
                              fontWeight: AppTextStyles.medium,
                            ),
                          ),
                          if (isPresent || isAbsent) ...[
                            SizedBox(width: 2),
                            Icon(
                              isPresent ? Icons.check : Icons.close,
                              size: 12,
                              color: _getDayTextColor(isPresent, isAbsent),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ],
    );
  }

  Color _getDayColor(bool isPresent, bool isAbsent) {
    if (isPresent) {
      return AppColors.success.withOpacity(0.2);
    } else if (isAbsent) {
      return AppColors.error.withOpacity(0.2);
    } else {
      return AppColors.gray100;
    }
  }

  Color _getDayTextColor(bool isPresent, bool isAbsent) {
    if (isPresent) {
      return AppColors.success;
    } else if (isAbsent) {
      return AppColors.error;
    } else {
      return AppColors.gray500;
    }
  }

  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  int _getFirstDayOfWeek(int year, int month) {
    return DateTime(year, month, 1).weekday;
  }
}
