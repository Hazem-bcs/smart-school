import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/zoom_meeting_bloc.dart';
import '../blocs/zoom_meeting_event.dart';

class TopicCard extends StatelessWidget {
  final TextEditingController controller;
  final String topic;

  const TopicCard({
    super.key,
    required this.controller,
    required this.topic,
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
                Icons.edit_note_rounded,
                color: isDark ? const Color(0xFF6366F1) : const Color(0xFF5A67D8),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'موضوع الاجتماع',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            onChanged: (value) {
              context.read<ZoomMeetingBloc>().add(TopicChanged(value));
            },
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF1E293B),
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: 'مثال: مراجعة الفصل الخامس',
              hintStyle: TextStyle(
                color: isDark ? Colors.white60 : const Color(0xFF94A3B8),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? const Color(0xFF2A2F45) : const Color(0xFFE2E8F0),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? const Color(0xFF2A2F45) : const Color(0xFFE2E8F0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? const Color(0xFF6366F1) : const Color(0xFF5A67D8),
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: isDark ? const Color(0xFF2A2F45) : const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 