import '../../domain/entities/quick_action_entity.dart';

class QuickActionModel extends QuickActionEntity {
  const QuickActionModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.iconPath,
    required super.route,
    super.count = 0,
    super.isActive = true,
  });

  factory QuickActionModel.fromJson(Map<String, dynamic> json) {
    return QuickActionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      iconPath: json['icon_path'] as String,
      route: json['route'] as String,
      count: json['count'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'icon_path': iconPath,
      'route': route,
      'count': count,
      'is_active': isActive,
    };
  }
}
