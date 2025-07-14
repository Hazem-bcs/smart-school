import 'package:flutter/material.dart';
import '../../domain/entities/meeting_option_entity.dart';
import 'switch_list_tile.dart';

class OptionsSection extends StatelessWidget {
  final List<MeetingOptionEntity> meetingOptions;
  final Map<String, bool> optionStates;

  const OptionsSection({
    super.key,
    required this.meetingOptions,
    required this.optionStates,
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
                Icons.settings_rounded,
                color: isDark ? const Color(0xFF6366F1) : const Color(0xFF5A67D8),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Meeting Options',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...meetingOptions.map((option) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CustomSwitchListTile(
                title: option.title,
                value: optionStates[option.id] ?? false,
                optionId: option.id,
                subtitle: option.description ?? '',
              ),
            );
          }),
        ],
      ),
    );
  }
} 