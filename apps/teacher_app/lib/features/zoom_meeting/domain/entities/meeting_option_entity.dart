import 'package:equatable/equatable.dart';

class MeetingOptionEntity extends Equatable {
  final String id;
  final String title;
  final bool isEnabled;
  final String? description;

  const MeetingOptionEntity({
    required this.id,
    required this.title,
    this.isEnabled = false,
    this.description,
  });

  @override
  List<Object?> get props => [id, title, isEnabled, description];
} 