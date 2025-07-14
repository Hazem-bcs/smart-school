import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/zoom_meeting_bloc.dart';
import '../blocs/zoom_meeting_event.dart';

class DateTimePickerField extends StatelessWidget {
  final String label;
  final IconData icon;
  final DateTime value;
  final bool isDatePicker;

  const DateTimePickerField({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.isDatePicker,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showPicker(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2F45) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? const Color(0xFF3A3F55) : const Color(0xFFE2E8F0),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF6366F1).withOpacity(0.2)
                      : const Color(0xFF5A67D8).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isDark ? const Color(0xFF6366F1) : const Color(0xFF5A67D8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white70 : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatValue(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: isDark ? Colors.white60 : const Color(0xFF94A3B8),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatValue() {
    if (isDatePicker) {
      // تنسيق التاريخ بشكل جميل: "15 Dec 2024"
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${value.day} ${months[value.month - 1]} ${value.year}';
    } else {
      // تنسيق الوقت بشكل جميل: "14:30"
      final hour = value.hour.toString().padLeft(2, '0');
      final minute = value.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }
  }

  void _showPicker(BuildContext context) {
    if (isDatePicker) {
      _showDatePicker(context);
    } else {
      _showTimePicker(context);
    }
  }

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: isDark ? const Color(0xFF6366F1) : const Color(0xFF5A67D8),
              onPrimary: Colors.white,
              surface: isDark ? const Color(0xFF1A1F35) : Colors.white,
              onSurface: isDark ? Colors.white : const Color(0xFF1E293B),
            ),
            dialogBackgroundColor: isDark ? const Color(0xFF1A1F35) : Colors.white,
          ),
          child: child!,
        );
      },
    ).then((selectedDate) {
      if (selectedDate != null) {
        context.read<ZoomMeetingBloc>().add(DateChanged(selectedDate));
      }
    });
  }

  void _showTimePicker(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(value),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: isDark ? const Color(0xFF6366F1) : const Color(0xFF5A67D8),
              onPrimary: Colors.white,
              surface: isDark ? const Color(0xFF1A1F35) : Colors.white,
              onSurface: isDark ? Colors.white : const Color(0xFF1E293B),
            ),
            dialogBackgroundColor: isDark ? const Color(0xFF1A1F35) : Colors.white,
          ),
          child: child!,
        );
      },
    ).then((selectedTime) {
      if (selectedTime != null) {
        final newDateTime = DateTime(
          value.year,
          value.month,
          value.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        context.read<ZoomMeetingBloc>().add(TimeChanged(newDateTime));
      }
    });
  }
} 