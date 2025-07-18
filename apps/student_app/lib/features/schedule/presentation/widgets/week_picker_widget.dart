import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // لتنسيق التاريخ باللغة العربية

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
  late DateTime _currentWeekStart; // بداية الأسبوع المعروض حالياً

  @override
  void initState() {
    super.initState();
    _currentWeekStart = _findStartOfWeek(
      widget.selectedDate,
    ); // تحديد بداية الأسبوع بناءً على التاريخ المختار
  }

  @override
  void didUpdateWidget(covariant WeekPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    // إذا تغير التاريخ المختار، نحدّث بداية الأسبوع لضمان عرض الأسبوع الصحيح
    if (widget.selectedDate.day != oldWidget.selectedDate.day ||
        widget.selectedDate.month != oldWidget.selectedDate.month ||
        widget.selectedDate.year != oldWidget.selectedDate.year) {
      setState(() {
        _currentWeekStart = _findStartOfWeek(widget.selectedDate);
      });
    }
  }

  // دالة مساعدة لإيجاد أول يوم في الأسبوع (الأحد، كما في صورتك)
  DateTime _findStartOfWeek(DateTime date) {
    // الأحد هو يوم 0 في الدالة weekday في Dart (الإثنين هو 1، وهكذا حتى السبت 6)
    // لذا نطرح عدد الأيام التي مضت من بداية الأسبوع للوصول إلى الأحد
    return date.subtract(Duration(days: date.weekday % 7));
  }

  // للانتقال إلى الأسبوع السابق
  void _goToPreviousWeek() {
    setState(() {
      _currentWeekStart = _currentWeekStart.subtract(const Duration(days: 7));
      _selectCorrespondingDay(); // نختار اليوم المقابل في الأسبوع الجديد
    });
  }

  // للانتقال إلى الأسبوع التالي
  void _goToNextWeek() {
    setState(() {
      _currentWeekStart = _currentWeekStart.add(const Duration(days: 7));
      _selectCorrespondingDay(); // نختار اليوم المقابل في الأسبوع الجديد
    });
  }

  // نختار اليوم المقابل في الأسبوع الجديد (مثلاً، إذا كان المختار "أربعاء"، نختار الأربعاء في الأسبوع الجديد)
  void _selectCorrespondingDay() {
    int selectedDayOfWeek =
        widget
            .selectedDate
            .weekday; // رقم اليوم في الأسبوع (1 للإثنين، 7 للأحد)
    // يجب أن نحول رقم اليوم ليتناسب مع أن الأحد هو 0 لبداية الأسبوع لدينا
    int daysToAdd = selectedDayOfWeek % 7;
    // إذا كان اليوم هو الأحد (7)، يصبح 0
    if (selectedDayOfWeek == DateTime.sunday) {
      daysToAdd = 0;
    }

    DateTime newSelectedDate = _currentWeekStart.add(Duration(days: daysToAdd));
    widget.onDateSelected(
      newSelectedDate,
    ); // نُبلغ الصفحة الرئيسية بالتاريخ الجديد المختار
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // توليد قائمة بأيام الأسبوع الحالية
    List<DateTime> currentWeekDays = List.generate(7, (index) {
      return _currentWeekStart.add(Duration(days: index));
    });

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A2E) : const Color(0xFFF8F9FA),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // جزء التنقل بين الأشهر والسنين
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: isDark ? Colors.white70 : Colors.black54,
                  size: 20,
                ),
                onPressed: _goToPreviousWeek,
              ),
              Text(
                // عرض الشهر والسنة باللغة العربية
                DateFormat('MMMM yyyy', 'en').format(_currentWeekStart),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0E141B),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: isDark ? Colors.white70 : Colors.black54,
                  size: 20,
                ),
                onPressed: _goToNextWeek,
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          // أيام الأسبوع
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                currentWeekDays.map((day) {
                  // التحقق مما إذا كان هذا اليوم هو اليوم المختار حالياً
                  final bool isSelected =
                      day.day == widget.selectedDate.day &&
                      day.month == widget.selectedDate.month &&
                      day.year == widget.selectedDate.year;

                  return GestureDetector(
                    onTap: () => widget.onDateSelected(day),
                    // عند النقر، نُبلغ عن التاريخ المختار
                    child: Column(
                      children: [
                        Text(
                          // اسم اليوم (أحد، إثنين...) باللغة العربية
                          DateFormat('EEE', 'en').format(day),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color:
                                isSelected
                                    ? (isDark
                                        ? Colors.white
                                        : theme.primaryColor)
                                    : (isDark
                                        ? Colors.white70
                                        : Colors.black54),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Container(
                          width: 32,
                          // حجم الدائرة لليوم
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? (isDark
                                        ? theme.primaryColor
                                        : theme
                                            .primaryColor) // لون الدائرة لليوم المختار
                                    : Colors
                                        .transparent, // شفافة إذا لم تكن مختارة
                            shape: BoxShape.circle,
                            border:
                                isSelected
                                    ? Border.all(
                                      color:
                                          isDark
                                              ? Colors.purpleAccent
                                              : theme.primaryColor,
                                      width: 1.5,
                                    )
                                    : null, // لا يوجد حدود إذا لم تكن مختارة
                          ),
                          child: Text(
                            // رقم اليوم
                            DateFormat('d').format(day),
                            style: theme.textTheme.titleSmall?.copyWith(
                              color:
                                  isSelected
                                      ? Colors.white
                                      : (isDark ? Colors.white : Colors.black),
                              fontWeight:
                                  isSelected
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
