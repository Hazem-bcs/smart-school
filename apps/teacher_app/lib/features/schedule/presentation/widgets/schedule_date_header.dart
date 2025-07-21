import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleDateHeader extends StatelessWidget {
  final DateTime selectedDate;

  const ScheduleDateHeader({
    super.key,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          DateFormat('d MMMM yyyy', 'ar').format(selectedDate),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
      ),
    );
  }
} 