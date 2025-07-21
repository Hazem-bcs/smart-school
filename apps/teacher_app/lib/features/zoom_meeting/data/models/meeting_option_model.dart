import '../../domain/entities/meeting_option_entity.dart';

class MeetingOptionModel {
  final String id;
  final String title;
  final bool isEnabled;
  final String? description;

  const MeetingOptionModel({
    required this.id,
    required this.title,
    this.isEnabled = false,
    this.description,
  });

  factory MeetingOptionModel.fromJson(Map<String, dynamic> json) {
    return MeetingOptionModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      isEnabled: json['isEnabled'] ?? false,
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isEnabled': isEnabled,
      'description': description,
    };
  }

  MeetingOptionEntity toEntity() => MeetingOptionEntity(
    id: id,
    title: title,
    isEnabled: isEnabled,
    description: description,
  );

  factory MeetingOptionModel.fromEntity(MeetingOptionEntity entity) => MeetingOptionModel(
    id: entity.id,
    title: entity.title,
    isEnabled: entity.isEnabled,
    description: entity.description,
  );
} 