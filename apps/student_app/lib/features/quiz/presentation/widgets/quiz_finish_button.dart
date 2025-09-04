import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';

class QuizFinishButton extends StatelessWidget {
  final bool isComplete;
  final VoidCallback? onPressed;
  final bool isDark;

  const QuizFinishButton({
    super.key,
    required this.isComplete,
    required this.onPressed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isComplete ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isComplete ? theme.colorScheme.primary : theme.disabledColor,
          foregroundColor: isComplete ? theme.colorScheme.onPrimary : theme.hintColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isComplete ? 4 : 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isComplete ? Icons.check_circle : Icons.lock,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              isComplete ? 'إنهاء الاختبار' : 'أجب على جميع الأسئلة أولاً',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
