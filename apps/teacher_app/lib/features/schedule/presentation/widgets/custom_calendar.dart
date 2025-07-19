import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive_helper.dart';

class CustomCalendar extends StatefulWidget {
  final DateTime currentMonth;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final Function(DateTime) onMonthChanged;

  const CustomCalendar({
    super.key,
    required this.currentMonth,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onMonthChanged,
  });

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar>
    with TickerProviderStateMixin {
  late AnimationController _monthTransitionController;
  late AnimationController _daySelectionController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _monthTransitionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _daySelectionController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _monthTransitionController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _daySelectionController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _monthTransitionController.dispose();
    _daySelectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      margin: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCalendarHeader(theme, isDark),
          _buildDaysOfWeek(theme, isDark),
          _buildCalendarGrid(theme, isDark),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader(ThemeData theme, bool isDark) {
    return Padding(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _previousMonth,
            icon: Icon(
              Icons.chevron_left,
              color: isDark ? Colors.white : const Color(0xFF0E141B),
            ),
          ),
          Text(
            _getMonthYearString(),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0E141B),
            ),
          ),
          IconButton(
            onPressed: _nextMonth,
            icon: Icon(
              Icons.chevron_right,
              color: isDark ? Colors.white : const Color(0xFF0E141B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysOfWeek(ThemeData theme, bool isDark) {
    const days = ['أحد', 'إثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة', 'سبت'];
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(context),
        vertical: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((day) => Expanded(
          child: SizedBox(
            height: 35,
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2C3E50),
                ),
              ),
            ),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid(ThemeData theme, bool isDark) {
    final daysInMonth = DateTime(widget.currentMonth.year, widget.currentMonth.month + 1, 0).day;
    final firstDayOfMonth = DateTime(widget.currentMonth.year, widget.currentMonth.month, 1);
    // Convert to Sunday = 0, Monday = 1, etc.
    final firstWeekday = firstDayOfMonth.weekday == 7 ? 0 : firstDayOfMonth.weekday;
    
    return SlideTransition(
      position: _slideAnimation,
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.0,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: 42, // 6 weeks * 7 days
          itemBuilder: (context, index) {
            final dayNumber = index - firstWeekday + 1;
            final isCurrentMonth = dayNumber > 0 && dayNumber <= daysInMonth;
            final isSelected = isCurrentMonth && 
                dayNumber == widget.selectedDate.day &&
                widget.currentMonth.month == widget.selectedDate.month &&
                widget.currentMonth.year == widget.selectedDate.year;
            
            if (!isCurrentMonth) {
              return const SizedBox.shrink(); // بدلاً من Container فارغ
            }
            
            return _buildDayCell(theme, isDark, dayNumber, isSelected);
          },
        ),
      ),
    );
  }

  Widget _buildDayCell(ThemeData theme, bool isDark, int dayNumber, bool isSelected) {
    final isToday = dayNumber == DateTime.now().day && 
                   widget.currentMonth.month == DateTime.now().month &&
                   widget.currentMonth.year == DateTime.now().year;
    
    return AnimatedBuilder(
      animation: _daySelectionController,
      builder: (context, child) {
        return Transform.scale(
          scale: isSelected ? _scaleAnimation.value : 1.0,
          child: GestureDetector(
            onTap: () => _onDaySelected(dayNumber),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected 
                    ? const Color(0xFF4A90E2)
                    : isToday
                        ? const Color(0xFF4A90E2).withOpacity(0.2)
                        : isDark 
                            ? const Color(0xFF2A2A3E)
                            : const Color(0xFFE8E8E8),
                shape: BoxShape.circle,
                border: isToday && !isSelected
                    ? Border.all(
                        color: const Color(0xFF4A90E2),
                        width: 2,
                      )
                    : null,
              ),
              child: Center(
                child: Text(
                  dayNumber.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.w600,
                    color: isSelected 
                        ? Colors.white
                        : isToday
                            ? const Color(0xFF4A90E2)
                            : isDark ? Colors.white : const Color(0xFF2C3E50),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getMonthYearString() {
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return '${months[widget.currentMonth.month - 1]} ${widget.currentMonth.year}';
  }

  void _previousMonth() {
    final newMonth = DateTime(widget.currentMonth.year, widget.currentMonth.month - 1);
    _animateMonthTransition(() {
      widget.onMonthChanged(newMonth);
    });
  }

  void _nextMonth() {
    final newMonth = DateTime(widget.currentMonth.year, widget.currentMonth.month + 1);
    _animateMonthTransition(() {
      widget.onMonthChanged(newMonth);
    });
  }

  void _animateMonthTransition(VoidCallback onComplete) {
    _monthTransitionController.forward().then((_) {
      onComplete();
      _monthTransitionController.reset();
    });
  }

  void _onDaySelected(int dayNumber) {
    final selectedDate = DateTime(widget.currentMonth.year, widget.currentMonth.month, dayNumber);
    widget.onDateSelected(selectedDate);
    
    _daySelectionController.forward().then((_) {
      _daySelectionController.reverse();
    });
  }
} 