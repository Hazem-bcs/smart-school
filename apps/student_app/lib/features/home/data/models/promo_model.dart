import '../../domain/entities/promo_entity.dart';

class PromoModel extends PromoEntity {
  const PromoModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.imageUrl,
    super.description,
    super.isActive,
    super.startDate,
    super.endDate,
    super.priority,
  });

  factory PromoModel.fromJson(Map<String, dynamic> json) {
    return PromoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      imageUrl: json['image_url'] as String,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      startDate: json['start_date'] != null 
          ? DateTime.parse(json['start_date'] as String)
          : null,
      endDate: json['end_date'] != null 
          ? DateTime.parse(json['end_date'] as String)
          : null,
      priority: json['priority'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'image_url': imageUrl,
      'description': description,
      'is_active': isActive,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'priority': priority,
    };
  }
}
