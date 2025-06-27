class QuestionEntity {
  final int questionNumber;
  final String question;
  final List<String> options;
  final int marks;
  final String correctAnswer;

  QuestionEntity({
    required this.options,
    required this.correctAnswer,
    required this.marks,
    required this.question,
    required this.questionNumber,
  });
}
