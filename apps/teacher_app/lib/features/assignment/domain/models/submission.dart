class Submission {
  final String id;
  final String studentId;
  final String studentName;
  final String assignmentId;
  final String response;
  final DateTime submittedAt;
  final List<String> attachments;
  final String? comment;
  final double? grade;
  final bool isGraded;

  Submission({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.assignmentId,
    required this.response,
    required this.submittedAt,
    required this.attachments,
    this.comment,
    this.grade,
    this.isGraded = false,
  });

  Submission copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? assignmentId,
    String? response,
    DateTime? submittedAt,
    List<String>? attachments,
    String? comment,
    double? grade,
    bool? isGraded,
  }) {
    return Submission(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      assignmentId: assignmentId ?? this.assignmentId,
      response: response ?? this.response,
      submittedAt: submittedAt ?? this.submittedAt,
      attachments: attachments ?? this.attachments,
      comment: comment ?? this.comment,
      grade: grade ?? this.grade,
      isGraded: isGraded ?? this.isGraded,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'assignmentId': assignmentId,
      'response': response,
      'submittedAt': submittedAt.toIso8601String(),
      'attachments': attachments,
      'comment': comment,
      'grade': grade,
      'isGraded': isGraded,
    };
  }

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      id: json['id'],
      studentId: json['studentId'],
      studentName: json['studentName'],
      assignmentId: json['assignmentId'],
      response: json['response'],
      submittedAt: DateTime.parse(json['submittedAt']),
      attachments: List<String>.from(json['attachments']),
      comment: json['comment'],
      grade: json['grade']?.toDouble(),
      isGraded: json['isGraded'] ?? false,
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(submittedAt);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  String toString() {
    return 'Submission(id: $id, studentName: $studentName, isGraded: $isGraded)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Submission &&
        other.id == id &&
        other.studentId == studentId &&
        other.studentName == studentName &&
        other.assignmentId == assignmentId &&
        other.response == response &&
        other.submittedAt == submittedAt &&
        other.attachments == attachments &&
        other.comment == comment &&
        other.grade == grade &&
        other.isGraded == isGraded;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        studentId.hashCode ^
        studentName.hashCode ^
        assignmentId.hashCode ^
        response.hashCode ^
        submittedAt.hashCode ^
        attachments.hashCode ^
        comment.hashCode ^
        grade.hashCode ^
        isGraded.hashCode;
  }
} 