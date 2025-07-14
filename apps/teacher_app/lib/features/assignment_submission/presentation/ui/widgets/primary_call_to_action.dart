import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';

class PrimaryCallToAction extends StatelessWidget {
  const PrimaryCallToAction({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return ElevatedButton.icon(
      onPressed: () {
        // TODO: Implement mark as graded logic
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Assignment marked as graded!'),
            backgroundColor: isDark ? AppColors.darkSuccess : AppColors.success,
          ),
        );
      },
      icon: const Icon(Icons.check_circle_outline),
      label: const Text('Mark as Graded'),
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark ? AppColors.darkAccentBlue : AppColors.info,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: isDark ? 4 : 2,
      ),
    );
  }
} 