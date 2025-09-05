import 'package:flutter/material.dart';
import 'primary_call_to_action.dart';

class ScheduleButton extends StatelessWidget {
  const ScheduleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? const Color(0xFF6366F1).withOpacity(0.3)
                : const Color(0xFF5A67D8).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: PrimaryCallToAction(
        label: 'جدولة الاجتماع',
        icon: Icons.video_call_rounded,
      ),
    );
  }
} 