import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:core/theme/index.dart';

class WeekPicker extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const WeekPicker({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<WeekPicker> createState() => _WeekPickerState();
}

class _WeekPickerState extends State<WeekPicker> {
  late DateTime _currentWeekStart;

  @override
  void initState() {
    super.initState();
    _currentWeekStart = _findStartOfWeek(widget.selectedDate);
  }

  @override
  void didUpdateWidget(covariant WeekPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate.day != oldWidget.selectedDate.day ||
        widget.selectedDate.month != oldWidget.selectedDate.month ||
        widget.selectedDate.year != oldWidget.selectedDate.year) {
      setState(() {
        _currentWeekStart = _findStartOfWeek(widget.selectedDate);
      });
    }
  }

  DateTime _findStartOfWeek(DateTime date) {
    // Dart: Monday=1..Sunday=7. We want week start = Sunday.
    // Days to subtract to reach Sunday: if Sunday (7) => 0, else weekday.
    final int daysToSubtract = date.weekday % 7; // Mon=1..Sat=6, Sun=0
    final result = DateTime(date.year, date.month, date.day).subtract(Duration(days: daysToSubtract));
    print('🔍 WeekPicker: _findStartOfWeek - Input: $date (${date.weekday}), Subtract: $daysToSubtract, Result: $result (${result.weekday})');
    return result;
  }

  void _goToPreviousWeek() {
    setState(() {
      _currentWeekStart = _currentWeekStart.subtract(const Duration(days: 7));
      _selectCorrespondingDay();
    });
  }

  void _goToNextWeek() {
    setState(() {
      _currentWeekStart = _currentWeekStart.add(const Duration(days: 7));
      _selectCorrespondingDay();
    });
  }

  void _selectCorrespondingDay() {
    // Monday=1..Sunday=7 → index 0..6, where 0=Mon, 6=Sun.
    // Our _currentWeekStart is always Sunday, so offset = (weekday % 7).
    final int offsetFromSunday = widget.selectedDate.weekday % 7; // Sun=0, Mon=1, ..., Sat=6
    final DateTime newSelectedDate = _currentWeekStart.add(Duration(days: offsetFromSunday));
    print('🔍 WeekPicker: _selectCorrespondingDay - Original: ${widget.selectedDate} (${widget.selectedDate.weekday}), New: $newSelectedDate (${newSelectedDate.weekday})');
    widget.onDateSelected(newSelectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    List<DateTime> currentWeekDays = List.generate(7, (index) {
      return _currentWeekStart.add(Duration(days: index));
    });

    print('🔍 WeekPicker: Current week start: $_currentWeekStart');
    print('🔍 WeekPicker: Current week days: ${currentWeekDays.map((d) => '${d.day}(${d.weekday})').toList()}');
    print('🔍 WeekPicker: Selected date: ${widget.selectedDate} (weekday: ${widget.selectedDate.weekday})');

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: isDark ? AppColors.darkSecondaryText : AppColors.gray500,
                  size: 20,
                ),
                onPressed: _goToPreviousWeek,
              ),
              Text(
                DateFormat('MMMM yyyy', 'en').format(_currentWeekStart),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.white : AppColors.gray900,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: isDark ? AppColors.darkSecondaryText : AppColors.gray500,
                  size: 20,
                ),
                onPressed: _goToNextWeek,
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: currentWeekDays.map((day) {
              final bool isSelected =
                  day.day == widget.selectedDate.day &&
                  day.month == widget.selectedDate.month &&
                  day.year == widget.selectedDate.year;

              return GestureDetector(
                onTap: () => widget.onDateSelected(day),
                child: Column(
                  children: [
                    Text(
                      DateFormat('EEE', 'en').format(day),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? (isDark ? AppColors.white : AppColors.primary)
                            : (isDark ? AppColors.darkSecondaryText : AppColors.gray500),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: AppColors.primary,
                                width: 1.5,
                              )
                            : null,
                      ),
                                              child: Text(
                          DateFormat('d').format(day),
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: isSelected
                                ? AppColors.white
                                : (isDark ? AppColors.white : AppColors.black),
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
