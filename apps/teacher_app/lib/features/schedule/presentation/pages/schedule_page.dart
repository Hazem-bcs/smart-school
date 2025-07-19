import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/responsive/responsive_widgets.dart';
import '../../../../core/widgets/shared_bottom_navigation.dart';
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

  DateTime _selectedDate = DateTime.now(); // التاريخ المختار حالياً

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

    _pageAnimationController.forward(); // بدء التحريك
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
                WeekPicker(
                  selectedDate: _selectedDate,
                  onDateSelected: _onDateSelected,
                ),
                // عرض التاريخ المختار (مثل الصورة التي أرسلتها)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    // محاذاة لليمين للنص العربي
                    child: Text(
                      // تنسيق التاريخ "الخميس، 18 يوليو 2025" باللغة العربية
                      ' ${DateFormat('d MMMM yyyy', 'ar').format(_selectedDate)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: AnimatedScheduleList(selectedDate: _selectedDate),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SharedBottomNavigation(
        currentIndex: 2, // مؤشر صفحة الجدول الزمني
      ),
    );
  }

  // بناء الـ AppBar الخاص بالصفحة
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
      // لا يوجد زر رجوع تلقائي
      backgroundColor:
          isDark ? const Color(0xFF1A1A2E) : const Color(0xFFF8F9FA),
      elevation: 0,
      // إزالة الظل
      centerTitle: true, // توسيط العنوان
    );
  }

  // عند اختيار تاريخ جديد
  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date; // تحديث التاريخ المختار
    });
  }
}
