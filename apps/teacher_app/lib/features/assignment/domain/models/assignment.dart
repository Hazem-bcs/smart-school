enum AssignmentStatus {
  all,
  ungraded,
  graded,
}

class Assignment {
  final String id;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final DateTime dueDate;
  final int submittedCount;
  final int totalCount;
  final AssignmentStatus status;

  Assignment({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.dueDate,
    required this.submittedCount,
    required this.totalCount,
    required this.status,
  });

  Assignment copyWith({
    String? id,
    String? title,
    String? subtitle,
    bool? isCompleted,
    DateTime? dueDate,
    int? submittedCount,
    int? totalCount,
    AssignmentStatus? status,
  }) {
    return Assignment(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      submittedCount: submittedCount ?? this.submittedCount,
      totalCount: totalCount ?? this.totalCount,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'isCompleted': isCompleted,
      'dueDate': dueDate.toIso8601String(),
      'submittedCount': submittedCount,
      'totalCount': totalCount,
      'status': status.name,
    };
  }

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      isCompleted: json['isCompleted'],
      dueDate: DateTime.parse(json['dueDate']),
      submittedCount: json['submittedCount'],
      totalCount: json['totalCount'],
      status: AssignmentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AssignmentStatus.all,
      ),
    );
  }

  @override
  String toString() {
    return 'Assignment(id: $id, title: $title, subtitle: $subtitle, isCompleted: $isCompleted, dueDate: $dueDate, submittedCount: $submittedCount, totalCount: $totalCount, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Assignment &&
        other.id == id &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.isCompleted == isCompleted &&
        other.dueDate == dueDate &&
        other.submittedCount == submittedCount &&
        other.totalCount == totalCount &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        subtitle.hashCode ^
        isCompleted.hashCode ^
        dueDate.hashCode ^
        submittedCount.hashCode ^
        totalCount.hashCode ^
        status.hashCode;
  }
} 