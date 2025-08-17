
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
      id: json['id'].toString(),
      description: json['description'] ?? '',
      amount: (json['amount'] as num).toDouble(),
      dueDate: DateTime.parse(json['due_date'] ?? json['dueDate'] ?? DateTime.now().toIso8601String()),
      isPaid: json['is_paid'] ?? json['isPaid'] ?? false,
    );
  }

  // Factory method for Laravel API response
  factory DueModel.fromLaravelResponse(Map<String, dynamic> json) {
    try {
      return DueModel(
        id: json['id']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        amount: double.tryParse(json['amount']?.toString() ?? '0.0') ?? 0.0,
        dueDate: DateTime.tryParse(json['due_date']?.toString() ?? '') ?? DateTime.now(),
        isPaid: json['is_paid'] == true || json['is_paid'] == 1,
      );
    } catch (e) {
      print('❌ Error parsing DueModel from Laravel response: $e');
      print('❌ JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'due_date': dueDate.toIso8601String(),
      'is_paid': isPaid,
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