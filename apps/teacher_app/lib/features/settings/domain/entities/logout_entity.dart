import 'package:equatable/equatable.dart';

class LogoutEntity extends Equatable {
  final bool success;
  final String? message;
  final String? userId;

  const LogoutEntity({
    required this.success,
    this.message,
    this.userId,
  });

  @override
  List<Object?> get props => [success, message, userId];
} 