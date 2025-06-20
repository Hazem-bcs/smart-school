import '../../../../theme/constants/colors.dart';
import '../../../../widgets/app_exports.dart';

class QuestionCard extends StatefulWidget {
  final int questionNumber;
  final String question;
  final List<String> options;
  final int marks;
  final String correctAnswer;
  final void Function(bool isCorrect)? onAnswered;

  const QuestionCard({
    super.key,
    required this.questionNumber,
    required this.question,
    required this.options,
    required this.marks,
    required this.correctAnswer,
    this.onAnswered,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  String? selectedAnswer;
  bool isChecked = false;


  void checkAnswer(String value) {
    setState(() {
      selectedAnswer = value;
      isChecked = true;
      final isCorrect = value == widget.correctAnswer;
      if (widget.onAnswered != null) {
        widget.onAnswered!(isCorrect);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: secondaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${widget.questionNumber} (marks: ${widget.marks})',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(widget.question),
            ),
            const SizedBox(height: 12),
            ...widget.options.map(
              (option) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: selectedAnswer,
                    onChanged: isChecked ? null : (value) => checkAnswer(value!),
                    activeColor:
                        isChecked
                            ? (option == widget.correctAnswer
                                ? Colors.green
                                : Colors.red)
                            : primaryColor,
                  ),
                  if (isChecked && option == selectedAnswer)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        option == widget.correctAnswer
                            ? '✔ true '
                            : '❌false, the correct is : ${widget.correctAnswer}',
                        style: TextStyle(
                          color:
                              option == widget.correctAnswer
                                  ? Colors.green
                                  : Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
