import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';
import 'package:core/widgets/index.dart';
import '../../../../widgets/modern_design/modern_effects.dart' as modern_effects;

class HomeworkLoadingState extends StatelessWidget {
  final bool isDark;

  const HomeworkLoadingState({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: modern_effects.ModernEffects.glassmorphism(
        isDark: isDark,
        opacity: 0.9,
        blur: 15.0,
        borderRadius: BorderRadius.circular(24),
        margin: const EdgeInsets.all(40),
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: modern_effects.ModernEffects.modernGradient(
                  isDark: isDark,
                  type: modern_effects.GradientTypeModern.primary,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: modern_effects.ModernEffects.modernShadow(
                  isDark: isDark,
                  type: modern_effects.ShadowType.glow,
                ),
              ),
              child: const Center(
                child: SmartSchoolLoading(
                  type: LoadingType.wave,
                  size: 50,
                  showMessage: false,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'جاري تحميل الواجبات...',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 20,
                color: isDark ? AppColors.darkPrimaryText : AppColors.gray800,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'يرجى الانتظار قليلاً',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
