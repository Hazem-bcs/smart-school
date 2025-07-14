import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/zoom_meeting_bloc.dart';
import '../blocs/zoom_meeting_event.dart';

class MultiSelectChipGroup extends StatelessWidget {
  final List<String> options;
  final List<String> selectedOptions;

  const MultiSelectChipGroup({
    super.key,
    required this.options,
    required this.selectedOptions,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: options.map((option) {
        final isSelected = selectedOptions.contains(option);
        return _buildChip(context, option, isSelected, isDark);
      }).toList(),
    );
  }

  Widget _buildChip(BuildContext context, String option, bool isSelected, bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            final isCurrentlySelected = selectedOptions.contains(option);
            context.read<ZoomMeetingBloc>().add(ClassSelectionChanged(option, !isCurrentlySelected));
          },
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                ? (isDark 
                    ? const Color(0xFF6366F1) 
                    : const Color(0xFF5A67D8))
                : (isDark 
                    ? const Color(0xFF2A2F45) 
                    : const Color(0xFFF1F5F9)),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                  ? (isDark 
                      ? const Color(0xFF6366F1) 
                      : const Color(0xFF5A67D8))
                  : (isDark 
                      ? const Color(0xFF3A3F55) 
                      : const Color(0xFFE2E8F0)),
                width: 1.5,
              ),
              boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: (isDark 
                        ? const Color(0xFF6366F1) 
                        : const Color(0xFF5A67D8)).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    size: 18,
                    color: Colors.white,
                  )
                else
                  Icon(
                    Icons.circle_outlined,
                    size: 18,
                    color: isDark 
                      ? Colors.white60 
                      : const Color(0xFF64748B),
                  ),
                const SizedBox(width: 8),
                Text(
                  option,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                      ? Colors.white
                      : (isDark 
                          ? Colors.white 
                          : const Color(0xFF1E293B)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 