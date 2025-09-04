import 'package:core/theme/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/widgets/app_exports.dart';
import 'package:core/theme/index.dart';
import 'package:core/widgets/index.dart';
import '../../../../widgets/modern_design/modern_effects.dart' as modern_effects;
import '../../../../widgets/app_bar_widget.dart';
import '../blocs/question_bloc/question_bloc.dart';
import '../widgets/question_card.dart';

class OneQuizPage extends StatefulWidget {
  final int questionId;

  const OneQuizPage({super.key, required this.questionId});

  @override
  State<OneQuizPage> createState() => _OneQuizPageState();
}

class _OneQuizPageState extends State<OneQuizPage> with TickerProviderStateMixin {
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<QuestionBloc, QuestionState>(
              builder: (context, state) {
                if (state is QuestionInitial || state is QuestionLoadingState) {
                  return _buildLoadingState(theme);
                } else if (state is QuestionFailureState) {
                  return _buildErrorState(state.message, theme);
                } else if (state is GetListQuestionLoadedState) {
                  return _buildQuizContent(state, theme);
                }
                return _buildEmptyState(theme);
              },
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    
    return AppBarWidget(
      title: 'الواجبات',
      actions: [
        AppBarActions.counter(
          text: '${answers.length}/${marks.length}',
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return const Center(
      child: SmartSchoolLoading(
        message: 'جاري تحميل الأسئلة...',
        type: LoadingType.dots,
        size: 60,
      ),
    );
  }

  Widget _buildErrorState(String message, ThemeData theme) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.error.withOpacity(0.1),
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
                color: theme.colorScheme.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                color: theme.colorScheme.error,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'حدث خطأ في التحميل',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
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
              icon: Icon(Icons.refresh, color: theme.colorScheme.onPrimary),
              label: Text('إعادة المحاولة', style: TextStyle(color: theme.colorScheme.onPrimary)),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
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

  Widget _buildQuizContent(GetListQuestionLoadedState state, ThemeData theme) {
    return Column(
      children: [
        // Progress Header
        _buildProgressHeader(state.questionList.length, theme),
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
        _buildFinishButton(theme),
      ],
    );
  }

  Widget _buildProgressHeader(int totalQuestions, ThemeData theme) {
    final answeredQuestions = answers.length;
    final progress = totalQuestions > 0 ? answeredQuestions / totalQuestions : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
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
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleMedium?.color,
                ),
              ),
              Text(
                '$answeredQuestions/$totalQuestions',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: theme.dividerColor,
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildFinishButton(ThemeData theme) {
    final totalQuestions = marks.length;
    final answeredQuestions = answers.length;
    final isComplete = answeredQuestions == totalQuestions && totalQuestions > 0;

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
        onPressed: isComplete ? finishExam : null,
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

  Widget _buildEmptyState(ThemeData theme) {
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
