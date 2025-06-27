import '../../domain/entites/question_entity.dart';

class QuestionModel {
  final int questionNumber;
  final String question;
  final List<String> options;
  final int marks;
  final String correctAnswer;

  QuestionModel({
    required this.questionNumber,
    required this.question,
    required this.options,
    required this.marks,
    required this.correctAnswer,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      questionNumber: json['questionNumber'] as int,
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      marks: json['marks'] as int,
      correctAnswer: json['correctAnswer'] as String,
    );
  }

  QuestionEntity toEntity() {
    return QuestionEntity(
      questionNumber: questionNumber,
      question: question,
      correctAnswer: correctAnswer,
      marks: marks,
      options: options,
    );
  }

}