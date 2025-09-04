import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';

class QuizEmptyState extends StatelessWidget {
  final bool isDark;

  const QuizEmptyState({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.quiz_outlined,
            size: 64,
            color: theme.hintColor,
          ),
          const SizedBox(height: 24),
          Text(
            'لا توجد أسئلة متاحة',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.hintColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
