class ClassModel {
  final String id;
  final String title;
  final String imageUrl;
  final int studentCount;
  final String subject;

  const ClassModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.studentCount = 0,
    required this.subject,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      studentCount: json['studentCount'] ?? 0,
      subject: json['subject'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'studentCount': studentCount,
      'subject': subject,
    };
  }
} 