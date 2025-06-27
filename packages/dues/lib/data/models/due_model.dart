
import '../../domain/entities/due_entity.dart';

class DueModel {
  final String id;
  final String description;
  final double amount;
  final DateTime dueDate;
  final bool isPaid;


  DueModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.dueDate,
    required this.isPaid,
  });

  factory DueModel.fromJson(Map<String, dynamic> json) {
    return DueModel(
      id: json['id'],
      description: json['description'],
      amount: (json['amount'] as num).toDouble(),
      dueDate: DateTime.parse(json['dueDate']),
      isPaid: json['isPaid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'isPaid': isPaid,
    };
  }

  DueEntity toEntity() {
    return DueEntity(
      id: id,
      description: description,
      amount: amount,
      isPaid: isPaid,
      dueDate: dueDate,
    );
  }
}