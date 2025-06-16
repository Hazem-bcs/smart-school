import 'dart:convert';

import '../../domain/entites/homework_entity.dart'; // For jsonEncode and jsonDecode

enum HomeworkStatus {
  pending,
  completed,
}

class HomeworkModel {
  final String id;
  final String title;
  final String subject;
  final DateTime assignedDate;
  final DateTime dueDate;
  final HomeworkStatus status;

  HomeworkModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.assignedDate,
    required this.dueDate,
    required this.status,
  });

  HomeworkModel copyWith({
    String? id,
    String? title,
    String? subject,
    DateTime? assignedDate,
    DateTime? dueDate,
    HomeworkStatus? status,
  }) {
    return HomeworkModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      assignedDate: assignedDate ?? this.assignedDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'assignedDate': assignedDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'status': status.name, // .name تحول الـ enum إلى String
    };
  }

  factory HomeworkModel.fromMap(Map<String, dynamic> map) {
    return HomeworkModel(
      id: map['id'] as String,
      title: map['title'] as String,
      subject: map['subject'] as String,
      assignedDate: DateTime.parse(map['assignedDate'] as String),
      dueDate: DateTime.parse(map['dueDate'] as String),
      // تحويل String إلى enum
      status: HomeworkStatus.values.firstWhere(
            (e) => e.name == map['status'],
        orElse: () => HomeworkStatus.pending, // قيمة افتراضية في حال الخطأ
      ),
    );
  }

  // 3. دوال toJson و fromJson (للتعامل مع البيانات كنص JSON)
  String toJson() => json.encode(toMap());

  factory HomeworkModel.fromJson(String source) =>
      HomeworkModel.fromMap(json.decode(source) as Map<String, dynamic>);


  // 4. دوال التحويل بين Model و Entity

  // دالة لتحويل Model إلى Entity
  HomeworkEntity toEntity() {
    return HomeworkEntity(
      id: id,
      title: title,
      subject: subject,
      assignedDate: assignedDate,
      dueDate: dueDate,
      status: status.name, // تحويل Enum إلى String
    );
  }

  // دالة (Constructor) لإنشاء Model من Entity
  factory HomeworkModel.fromEntity(HomeworkEntity entity) {
    return HomeworkModel(
      id: entity.id,
      title: entity.title,
      subject: entity.subject,
      assignedDate: entity.assignedDate,
      dueDate: entity.dueDate,
      // تحويل String من الـ Entity إلى Enum للـ Model
      status: HomeworkStatus.values.firstWhere(
            (e) => e.name == entity.status,
        orElse: () => HomeworkStatus.pending,
      ),
    );
  }
}