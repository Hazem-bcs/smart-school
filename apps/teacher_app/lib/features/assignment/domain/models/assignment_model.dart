class AssignmentModel {
  final String? title;
  final String? description;
  final List<String> attachments;
  final DateTime? dueDate;
  final String? targetClass;
  final int? maxPoints;
  final bool isDraft;

  AssignmentModel({
    this.title,
    this.description,
    this.attachments = const [],
    this.dueDate,
    this.targetClass,
    this.maxPoints,
    this.isDraft = false,
  });

  AssignmentModel copyWith({
    String? title,
    String? description,
    List<String>? attachments,
    DateTime? dueDate,
    String? targetClass,
    int? maxPoints,
    bool? isDraft,
  }) {
    return AssignmentModel(
      title: title ?? this.title,
      description: description ?? this.description,
      attachments: attachments ?? this.attachments,
      dueDate: dueDate ?? this.dueDate,
      targetClass: targetClass ?? this.targetClass,
      maxPoints: maxPoints ?? this.maxPoints,
      isDraft: isDraft ?? this.isDraft,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'attachments': attachments,
      'dueDate': dueDate?.toIso8601String(),
      'targetClass': targetClass,
      'maxPoints': maxPoints,
      'isDraft': isDraft,
    };
  }

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      title: json['title'],
      description: json['description'],
      attachments: List<String>.from(json['attachments'] ?? []),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      targetClass: json['targetClass'],
      maxPoints: json['maxPoints'],
      isDraft: json['isDraft'] ?? false,
    );
  }

  bool get isValid {
    return title != null && 
           title!.isNotEmpty && 
           description != null && 
           description!.isNotEmpty &&
           targetClass != null &&
           maxPoints != null &&
           maxPoints! > 0;
  }

  String? get validationError {
    if (title == null || title!.isEmpty) {
      return 'Title is required';
    }
    if (description == null || description!.isEmpty) {
      return 'Description is required';
    }
    if (targetClass == null || targetClass!.isEmpty) {
      return 'Please select a target class';
    }
    if (maxPoints == null || maxPoints! <= 0) {
      return 'Maximum points must be greater than 0';
    }
    return null;
  }

  @override
  String toString() {
    return 'AssignmentModel(title: $title, description: $description, attachments: $attachments, dueDate: $dueDate, targetClass: $targetClass, maxPoints: $maxPoints, isDraft: $isDraft)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AssignmentModel &&
        other.title == title &&
        other.description == description &&
        other.attachments == attachments &&
        other.dueDate == dueDate &&
        other.targetClass == targetClass &&
        other.maxPoints == maxPoints &&
        other.isDraft == isDraft;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        description.hashCode ^
        attachments.hashCode ^
        dueDate.hashCode ^
        targetClass.hashCode ^
        maxPoints.hashCode ^
        isDraft.hashCode;
  }
} 