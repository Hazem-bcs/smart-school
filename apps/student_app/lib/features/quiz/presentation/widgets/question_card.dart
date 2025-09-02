import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';
import '../../../../widgets/app_exports.dart';
import '../../../../widgets/modern_design/modern_effects.dart';

class QuestionCard extends StatefulWidget {
  final int questionNumber;
  final String question;
  final List<String> options;
  final int marks;
  final String correctAnswer;
  final void Function(bool isCorrect)? onAnswered;
  final void Function(int questionNumber, bool isCorrect, int marks) onAnswerSelected;

  const QuestionCard({
    super.key,
    required this.questionNumber,
    required this.question,
    required this.options,
    required this.marks,
    required this.correctAnswer,
    this.onAnswered,
    required this.onAnswerSelected,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> with TickerProviderStateMixin {
  String? selectedAnswer;
  bool isChecked = false;
  late AnimationController _cardController;
  late AnimationController _optionController;
  late Animation<double> _cardAnimation;
  late Animation<double> _optionAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _optionController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOutCubic),
    );
    _optionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _optionController, curve: Curves.easeOutCubic),
    );

    _cardController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _optionController.forward();
    });
  }

  @override
  void dispose() {
    _cardController.dispose();
    _optionController.dispose();
    super.dispose();
  }

  void checkAnswer(String value) {
    setState(() {
      selectedAnswer = value;
      isChecked = true;
      final isCorrect = value == widget.correctAnswer;

      if (widget.onAnswered != null) {
        widget.onAnswered!(isCorrect);
      }

      widget.onAnswerSelected(widget.questionNumber, isCorrect, widget.marks);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return FadeTransition(
      opacity: _cardAnimation,
      child: Transform.translate(
        offset: Offset(0, 20 * (1 - _cardAnimation.value)),
        child: ModernEffects.glassmorphism(
          isDark: isDark,
          opacity: 0.95,
          blur: 15.0,
          borderRadius: BorderRadius.circular(24),
          margin: const EdgeInsets.only(bottom: 24),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: ModernEffects.modernShadow(
                isDark: isDark,
                type: ShadowType.medium,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question Header
                _buildQuestionHeader(theme, isDark),
                
                // Question Content
                _buildQuestionContent(theme, isDark),
                
                // Options
                _buildOptions(theme, isDark),
                
                // Result Feedback
                if (isChecked) _buildResultFeedback(theme, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionHeader(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: ModernEffects.modernGradient(
          isDark: isDark,
          type: GradientType.primary,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                '${widget.questionNumber}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'السؤال ${widget.questionNumber}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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
                    '${widget.marks} نقطة',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionContent(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Text(
        widget.question,
        style: TextStyle(
          fontSize: 18,
          color: isDark ? AppColors.darkPrimaryText : AppColors.gray800,
          height: 1.7,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildOptions(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: widget.options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final isSelected = selectedAnswer == option;
          final isCorrect = option == widget.correctAnswer;
          
          return FadeTransition(
            opacity: _optionAnimation,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - _optionAnimation.value)),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: _buildOptionTile(
                  option: option,
                  index: index,
                  isSelected: isSelected,
                  isCorrect: isCorrect,
                  theme: theme,
                  isDark: isDark,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOptionTile({
    required String option,
    required int index,
    required bool isSelected,
    required bool isCorrect,
    required ThemeData theme,
    required bool isDark,
  }) {
    Color borderColor = isDark ? AppColors.darkDivider : AppColors.gray200;
    Color backgroundColor = Colors.transparent;
    Color textColor = isDark ? AppColors.darkPrimaryText : AppColors.gray800;
    IconData? icon;
    Color iconColor = Colors.transparent;

    if (isChecked) {
      if (isCorrect) {
        borderColor = isDark ? AppColors.darkSuccess : AppColors.success;
        backgroundColor = (isDark ? AppColors.darkSuccess : AppColors.success).withOpacity(0.1);
        textColor = isDark ? AppColors.darkSuccess : AppColors.success;
        icon = Icons.check_circle_rounded;
        iconColor = isDark ? AppColors.darkSuccess : AppColors.success;
      } else if (isSelected) {
        borderColor = isDark ? AppColors.darkDestructive : AppColors.error;
        backgroundColor = (isDark ? AppColors.darkDestructive : AppColors.error).withOpacity(0.1);
        textColor = isDark ? AppColors.darkDestructive : AppColors.error;
        icon = Icons.cancel_rounded;
        iconColor = isDark ? AppColors.darkDestructive : AppColors.error;
      }
    } else if (isSelected) {
      borderColor = isDark ? AppColors.darkAccentBlue : AppColors.primary;
      backgroundColor = (isDark ? AppColors.darkAccentBlue : AppColors.primary).withOpacity(0.1);
      textColor = isDark ? AppColors.darkAccentBlue : AppColors.primary;
    }

    return GestureDetector(
      onTap: isChecked ? null : () => checkAnswer(option),
      child: ModernEffects.neumorphism(
        isDark: isDark,
        distance: isSelected ? 2.0 : 3.0,
        intensity: 0.08,
        borderRadius: BorderRadius.circular(18),
        isPressed: isSelected && !isChecked,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: borderColor.withOpacity(0.3), 
              width: isSelected || isChecked ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              // Option Letter
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: isSelected || isChecked 
                    ? LinearGradient(
                        colors: [borderColor, borderColor.withOpacity(0.8)],
                      )
                    : LinearGradient(
                        colors: [
                          isDark ? AppColors.darkElevatedSurface : AppColors.gray100,
                          isDark ? AppColors.darkCardBackground : AppColors.gray50,
                        ],
                      ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected || isChecked ? [
                    BoxShadow(
                      color: borderColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ] : null,
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index), // A, B, C, D
                    style: TextStyle(
                      color: isSelected || isChecked 
                        ? Colors.white 
                        : (isDark ? AppColors.darkSecondaryText : AppColors.gray600),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              
              // Option Text
              Expanded(
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 17,
                    color: textColor,
                    fontWeight: isSelected || isChecked ? FontWeight.w600 : FontWeight.w500,
                    letterSpacing: 0.3,
                    height: 1.4,
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Status Icon
              if (icon != null)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 28,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultFeedback(ThemeData theme, bool isDark) {
    final isCorrect = selectedAnswer == widget.correctAnswer;
    final feedbackColor = isCorrect 
      ? (isDark ? AppColors.darkSuccess : AppColors.success)
      : (isDark ? AppColors.darkDestructive : AppColors.error);
    
    return Container(
      margin: const EdgeInsets.all(24),
      child: ModernEffects.neumorphism(
        isDark: isDark,
        distance: 2.0,
        intensity: 0.1,
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                feedbackColor.withOpacity(0.1),
                feedbackColor.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: feedbackColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: feedbackColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isCorrect ? Icons.check_circle_rounded : Icons.info_rounded,
                  color: feedbackColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCorrect ? 'إجابة صحيحة!' : 'إجابة خاطئة',
                      style: TextStyle(
                        fontSize: 16,
                        color: feedbackColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isCorrect 
                        ? 'أحسنت، استمر في التقدم'
                        : 'الإجابة الصحيحة هي: ${widget.correctAnswer}',
                      style: TextStyle(
                        fontSize: 14,
                        color: feedbackColor,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

