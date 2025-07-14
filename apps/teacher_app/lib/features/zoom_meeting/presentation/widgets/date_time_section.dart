import 'package:flutter/material.dart';
import 'date_time_picker_field.dart';

class DateTimeSection extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime selectedTime;

  const DateTimeSection({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F35) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2F45) : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.1)
                : Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                color: isDark ? const Color(0xFF6366F1) : const Color(0xFF5A67D8),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Date & Time',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DateTimePickerField(
                  label: 'Date',
                  icon: Icons.calendar_today_rounded,
                  value: selectedDate,
                  isDatePicker: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DateTimePickerField(
                  label: 'Time',
                  icon: Icons.access_time_rounded,
                  value: selectedTime,
                  isDatePicker: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 