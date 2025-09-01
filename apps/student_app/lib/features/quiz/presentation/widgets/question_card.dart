import 'package:flutter/material.dart';
import '../../../../widgets/app_exports.dart';

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
    return FadeTransition(
      opacity: _cardAnimation,
      child: Transform.translate(
        offset: Offset(0, 20 * (1 - _cardAnimation.value)),
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4F46E5).withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question Header
              _buildQuestionHeader(),
              
              // Question Content
              _buildQuestionContent(),
              
              // Options
              _buildOptions(),
              
              // Result Feedback
              if (isChecked) _buildResultFeedback(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF4F46E5).withOpacity(0.05),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${widget.questionNumber}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'السؤال ${widget.questionNumber}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  '${widget.marks} نقطة',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Text(
        widget.question,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF334155),
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                margin: const EdgeInsets.only(bottom: 12),
                child: _buildOptionTile(
                  option: option,
                  index: index,
                  isSelected: isSelected,
                  isCorrect: isCorrect,
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
  }) {
    Color borderColor = const Color(0xFFE2E8F0);
    Color backgroundColor = Colors.white;
    Color textColor = const Color(0xFF334155);
    IconData? icon;
    Color iconColor = Colors.transparent;

    if (isChecked) {
      if (isCorrect) {
        borderColor = const Color(0xFF10B981);
        backgroundColor = const Color(0xFF10B981).withOpacity(0.1);
        textColor = const Color(0xFF10B981);
        icon = Icons.check_circle;
        iconColor = const Color(0xFF10B981);
      } else if (isSelected) {
        borderColor = const Color(0xFFEF4444);
        backgroundColor = const Color(0xFFEF4444).withOpacity(0.1);
        textColor = const Color(0xFFEF4444);
        icon = Icons.cancel;
        iconColor = const Color(0xFFEF4444);
      }
    } else if (isSelected) {
      borderColor = const Color(0xFF4F46E5);
      backgroundColor = const Color(0xFF4F46E5).withOpacity(0.1);
      textColor = const Color(0xFF4F46E5);
    }

    return GestureDetector(
      onTap: isChecked ? null : () => checkAnswer(option),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Option Letter
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected || isChecked ? borderColor : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index), // A, B, C, D
                  style: TextStyle(
                    color: isSelected || isChecked ? Colors.white : const Color(0xFF64748B),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Option Text
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                  fontWeight: isSelected || isChecked ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            
            // Status Icon
            if (icon != null)
              Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultFeedback() {
    final isCorrect = selectedAnswer == widget.correctAnswer;
    
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect 
            ? const Color(0xFF10B981).withOpacity(0.1)
            : const Color(0xFFEF4444).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect 
              ? const Color(0xFF10B981)
              : const Color(0xFFEF4444),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect ? Icons.check_circle : Icons.info_outline,
            color: isCorrect 
                ? const Color(0xFF10B981)
                : const Color(0xFFEF4444),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isCorrect 
                  ? 'إجابة صحيحة! أحسنت'
                  : 'إجابة خاطئة. الإجابة الصحيحة هي: ${widget.correctAnswer}',
              style: TextStyle(
                fontSize: 14,
                color: isCorrect 
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
