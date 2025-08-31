import '../../../../widgets/app_exports.dart';

class QuestionTrueFalseCard extends StatefulWidget {
  final int questionNumber;
  final String question;
  final bool correctAnswer;
  final int marks;
  final void Function(bool isCorrect)? onAnswered;

  const QuestionTrueFalseCard({
    super.key,
    required this.questionNumber,
    required this.question,
    required this.correctAnswer,
    required this.marks,
    this.onAnswered,
  });

  @override
  State<QuestionTrueFalseCard> createState() => _QuestionTrueFalseCardState();
}

class _QuestionTrueFalseCardState extends State<QuestionTrueFalseCard> {
  bool? selectedAnswer;
  bool isChecked = false;

  void checkAnswer(bool value) {
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
            RadioListTile<bool>(
              title: const Text('True'),
              value: true,
              groupValue: selectedAnswer,
              onChanged: isChecked ? null : (value) => checkAnswer(value!),
              activeColor:
                  isChecked
                      ? (true == widget.correctAnswer
                          ? Colors.green
                          : Colors.red)
                      : primaryColor,
            ),
            if (isChecked && selectedAnswer == true)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  selectedAnswer == widget.correctAnswer
                      ? '✔ true '
                      : '❌false,the correct is :  ${widget.correctAnswer ? "True" : "False"}',
                  style: TextStyle(
                    color:
                        selectedAnswer == widget.correctAnswer
                            ? Colors.green
                            : Colors.red,
                  ),
                ),
              ),
            RadioListTile<bool>(
              title: const Text('False'),
              value: false,
              groupValue: selectedAnswer,
              onChanged: isChecked ? null : (value) => checkAnswer(value!),
              activeColor:
                  isChecked
                      ? (false == widget.correctAnswer
                          ? Colors.green
                          : Colors.red)
                      : primaryColor,
            ),
            if (isChecked && selectedAnswer == false)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  selectedAnswer == widget.correctAnswer
                      ? '✔ true '
                      : '❌ false ,the correct is : ${widget.correctAnswer ? "True" : "False"}',
                  style: TextStyle(
                    color:
                        selectedAnswer == widget.correctAnswer
                            ? Colors.green
                            : Colors.red,
                  ),
                ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
