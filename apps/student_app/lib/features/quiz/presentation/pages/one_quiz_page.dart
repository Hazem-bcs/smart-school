import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/widgets/app_exports.dart';
import '../blocs/question_bloc/question_bloc.dart';
import '../widgets/question_card.dart';

class OneHomeworkPage extends StatefulWidget {
  final int questionId;

  const OneHomeworkPage({super.key, required this.questionId});

  @override
  State<OneHomeworkPage> createState() => _OneHomeworkPageState();
}

class _OneHomeworkPageState extends State<OneHomeworkPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    context.read<QuestionBloc>().add(
      GetListQuestionEvent(homeWorkId: widget.questionId),
    );
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  final Map<int, bool> answers = {};
  final Map<int, int> marks = {};

  int get totalScore {
    int sum = 0;
    answers.forEach((key, value) {
      if (value == true) {
        sum += marks[key] ?? 0;
      }
    });
    return sum;
  }

  void finishExam() {
    final totalMarks = marks.values.fold(0, (a, b) => a + b);
    final percentage = totalMarks > 0 ? (totalScore / totalMarks) * 100.0 : 0.0;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _ExamResultDialog(
        totalScore: totalScore,
        totalMarks: totalMarks,
        percentage: percentage,
        onAccept: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<QuestionBloc, QuestionState>(
              builder: (context, state) {
                if (state is QuestionInitial || state is QuestionLoadingState) {
                  return _buildLoadingState();
                } else if (state is QuestionFailureState) {
                  return _buildErrorState(state.message);
                } else if (state is GetListQuestionLoadedState) {
                  return _buildQuizContent(state);
                }
                return _buildEmptyState();
              },
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF4F46E5),
      title: Text(
        AppStrings.homeWork,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        Container(
          margin: const EdgeInsetsDirectional.only(end: 16.0),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.timer,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                '${answers.length}/${marks.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4F46E5)),
            strokeWidth: 3,
          ),
          SizedBox(height: 24),
          Text(
            'جاري تحميل الأسئلة...',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'حدث خطأ في التحميل',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<QuestionBloc>().add(
                  GetListQuestionEvent(homeWorkId: widget.questionId),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizContent(GetListQuestionLoadedState state) {
    return Column(
      children: [
        // Progress Header
        _buildProgressHeader(state.questionList.length),
        const SizedBox(height: 20),
        
        // Questions List
        Expanded(
          child: ListView.builder(
            itemCount: state.questionList.length,
            itemBuilder: (context, index) {
              final question = state.questionList[index];
              
              if (!marks.containsKey(question.questionNumber)) {
                marks[question.questionNumber] = question.marks;
              }

              return AnimatedBuilder(
                animation: _fadeController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - _fadeController.value)),
                    child: Opacity(
                      opacity: _fadeController.value,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: QuestionCard(
                          questionNumber: question.questionNumber,
                          question: question.question,
                          options: question.options,
                          marks: question.marks,
                          correctAnswer: question.correctAnswer,
                          onAnswerSelected: (int qNum, bool isCorrect, int qMarks) {
                            setState(() {
                              answers[qNum] = isCorrect;
                              marks[qNum] = qMarks;
                            });
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        
        // Finish Button
        _buildFinishButton(),
      ],
    );
  }

  Widget _buildProgressHeader(int totalQuestions) {
    final answeredQuestions = answers.length;
    final progress = totalQuestions > 0 ? answeredQuestions / totalQuestions : 0.0;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'التقدم',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                '$answeredQuestions/$totalQuestions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF4F46E5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4F46E5)),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildFinishButton() {
    final totalQuestions = marks.length;
    final answeredQuestions = answers.length;
    final isComplete = answeredQuestions == totalQuestions && totalQuestions > 0;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isComplete ? finishExam : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isComplete ? const Color(0xFF4F46E5) : Colors.grey[300],
          foregroundColor: isComplete ? Colors.white : Colors.grey[600],
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.quiz_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'لا توجد أسئلة متاحة',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExamResultDialog extends StatelessWidget {
  final int totalScore;
  final int totalMarks;
  final double percentage;
  final VoidCallback onAccept;

  const _ExamResultDialog({
    required this.totalScore,
    required this.totalMarks,
    required this.percentage,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    final isExcellent = percentage >= 90;
    final isGood = percentage >= 80;
    final isPass = percentage >= 60;
    
    Color resultColor;
    IconData resultIcon;
    String resultText;
    String resultSubtext;

    if (isExcellent) {
      resultColor = const Color(0xFF10B981);
      resultIcon = Icons.emoji_events;
      resultText = 'ممتاز!';
      resultSubtext = 'أداء رائع!';
    } else if (isGood) {
      resultColor = const Color(0xFF3B82F6);
      resultIcon = Icons.thumb_up;
      resultText = 'جيد جداً!';
      resultSubtext = 'أداء مميز!';
    } else if (isPass) {
      resultColor = const Color(0xFFF59E0B);
      resultIcon = Icons.check_circle;
      resultText = 'مقبول';
      resultSubtext = 'أداء جيد!';
    } else {
      resultColor = const Color(0xFFEF4444);
      resultIcon = Icons.sentiment_dissatisfied;
      resultText = 'يحتاج تحسين';
      resultSubtext = 'استمر في التعلم!';
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              resultColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Result Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: resultColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                resultIcon,
                color: resultColor,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            
            // Result Title
            Text(
              resultText,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: resultColor,
              ),
            ),
            const SizedBox(height: 8),
            
            // Result Subtitle
            Text(
              resultSubtext,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            
            // Score Display
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: resultColor.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    '$totalScore',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: resultColor,
                    ),
                  ),
                  Text(
                    'من $totalMarks',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: resultColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Accept Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onAccept,
                style: ElevatedButton.styleFrom(
                  backgroundColor: resultColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'قبول النتيجة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
