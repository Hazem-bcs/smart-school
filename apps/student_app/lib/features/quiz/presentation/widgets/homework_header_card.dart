import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';
import '../../../../widgets/modern_design/modern_effects.dart' as modern_effects;

class HomeworkHeaderCard extends StatelessWidget {
  final int homeworkCount;
  final bool isDark;

  const HomeworkHeaderCard({
    super.key,
    required this.homeworkCount,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return modern_effects.ModernEffects.glassmorphism(
      isDark: isDark,
      opacity: 0.95,
      blur: 20.0,
      borderRadius: BorderRadius.circular(24),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          gradient: modern_effects.ModernEffects.modernGradient(
            isDark: isDark,
            type: modern_effects.GradientTypeModern.primary,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: modern_effects.ModernEffects.modernShadow(
            isDark: isDark,
            type: modern_effects.ShadowType.glow,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.assignment_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الواجبات المتاحة',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$homeworkCount واجب متاح',
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
