import 'package:smart_school/widgets/app_exports.dart';

import '../widgets/question_card.dart';
import '../widgets/question_true_false_card.dart';

class OneHomeworkPage extends StatefulWidget {
  const OneHomeworkPage({super.key});

  @override
  State<OneHomeworkPage> createState() => _OneHomeworkPageState();
}

class _OneHomeworkPageState extends State<OneHomeworkPage> {
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
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('result of exam'),
            content: Text(
              'your mark is  $totalScore from ${marks.values.fold(0, (a, b) => a + b)}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('accept'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: AppStrings.homeWork),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            QuestionCard(
              questionNumber: 1,
              question: 'What is the programming language of Flutter?',
              options: ['dart', '++c', 'java script'],
              marks: 3,
              correctAnswer:'dart',
              onAnswered: (isCorrect) {
                setState(() {
                  answers[1] = isCorrect;
                  marks[1] = 3;
                });
              },
            ),
            QuestionTrueFalseCard(
              questionNumber: 2,
              question: 'Flutter is developed by Google.',
              correctAnswer: true,
              marks: 9,
              onAnswered: (isCorrect) {
                setState(() {
                  answers[2] = isCorrect;
                  marks[2] = 9;
                });
              },
            ),
            QuestionCard(
              questionNumber: 3,
              question: 'What is the programming language of Flutter?',
              options: ['dart', '++c', 'java script'],
              marks: 3,
              correctAnswer: 'dart',
              onAnswered: (isCorrect) {
                setState(() {
                  answers[3] = isCorrect;
                  marks[3] = 3;
                });
              },
            ),
            QuestionTrueFalseCard(
              questionNumber: 4,
              question: 'Flutter is developed by Google.',
              correctAnswer: true,
              marks: 9,
              onAnswered: (isCorrect) {
                setState(() {
                  answers[4] = isCorrect;
                  marks[4] = 9;
                });
              },
            ),
            ElevatedButton(
              onPressed: finishExam,
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(primaryColor),
              ),
              child: const Text(
                'finish exam ',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
