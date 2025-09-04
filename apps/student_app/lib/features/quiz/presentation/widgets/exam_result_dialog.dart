import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';
import '../../../../widgets/modern_design/modern_effects.dart' as modern_effects;

class ExamResultDialog extends StatelessWidget {
  final int totalScore;
  final int totalMarks;
  final double percentage;
  final VoidCallback onAccept;

  const ExamResultDialog({
    super.key,
    required this.totalScore,
    required this.totalMarks,
    required this.percentage,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final isExcellent = percentage >= 90;
    final isGood = percentage >= 80;
    final isPass = percentage >= 60;

    Color resultColor;
    IconData resultIcon;
    String resultText;
    String resultSubtext;

    if (isExcellent) {
      resultColor = isDark ? AppColors.darkSuccess : AppColors.success;
      resultIcon = Icons.emoji_events_rounded;
      resultText = 'ممتاز!';
      resultSubtext = 'أداء رائع ومتميز!';
    } else if (isGood) {
      resultColor = isDark ? AppColors.darkAccentBlue : AppColors.primary;
      resultIcon = Icons.thumb_up_rounded;
      resultText = 'جيد جداً!';
      resultSubtext = 'أداء مميز!';
    } else if (isPass) {
      resultColor = isDark ? AppColors.darkWarning : AppColors.warning;
      resultIcon = Icons.check_circle_rounded;
      resultText = 'مقبول';
      resultSubtext = 'أداء جيد!';
    } else {
      resultColor = isDark ? AppColors.darkDestructive : AppColors.error;
      resultIcon = Icons.sentiment_dissatisfied_rounded;
      resultText = 'يحتاج تحسين';
      resultSubtext = 'استمر في التعلم والتدريب!';
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      child: modern_effects.ModernEffects.glassmorphism(
        isDark: isDark,
        opacity: 0.95,
        blur: 25.0,
        borderOpacity: 0.3,
        borderRadius: BorderRadius.circular(32),
        padding: const EdgeInsets.all(32),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                resultColor.withOpacity(0.1),
                resultColor.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: modern_effects.ModernEffects.modernShadow(
              isDark: isDark,
              type: modern_effects.ShadowType.glow,
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Result Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      resultColor.withOpacity(0.2),
                      resultColor.withOpacity(0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: resultColor.withOpacity(0.3),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: resultColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  resultIcon,
                  color: resultColor,
                  size: 50,
                ),
              ),
              const SizedBox(height: 32),

              // Result Title
              Text(
                resultText,
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: resultColor,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 12),

              // Result Subtitle
              Text(
                resultSubtext,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.hintColor,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Score Display
              modern_effects.ModernEffects.neumorphism(
                isDark: isDark,
                distance: 4.0,
                intensity: 0.1,
                borderRadius: BorderRadius.circular(24),
                padding: const EdgeInsets.all(32),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$totalScore',
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: resultColor,
                        ),
                      ),
                      Text(
                        'من $totalMarks',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.hintColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: resultColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: resultColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: resultColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Accept Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: modern_effects.ModernEffects.modernGradient(
                      isDark: isDark,
                      type: isExcellent ? modern_effects.GradientTypeModern.success :
                      isGood ? modern_effects.GradientTypeModern.primary :
                      isPass ? modern_effects.GradientTypeModern.warning : modern_effects.GradientTypeModern.primary,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: resultColor.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'قبول النتيجة',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
