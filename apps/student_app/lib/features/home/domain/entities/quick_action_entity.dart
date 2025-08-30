import 'package:equatable/equatable.dart';

class QuickActionEntity extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String iconPath;
  final String route;
  final int count;
  final bool isActive;

  const QuickActionEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.route,
    this.count = 0,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        iconPath,
        route,
        count,
        isActive,
      ];
}
