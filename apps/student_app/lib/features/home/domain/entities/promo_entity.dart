import 'package:equatable/equatable.dart';

class PromoEntity extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String? description;
  final bool isActive;
  final DateTime? startDate;
  final DateTime? endDate;
  final int priority;

  const PromoEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.description,
    this.isActive = true,
    this.startDate,
    this.endDate,
    this.priority = 0,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        imageUrl,
        description,
        isActive,
        startDate,
        endDate,
        priority,
      ];
}
