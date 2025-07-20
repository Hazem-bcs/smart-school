import '../../domain/entities/logout_entity.dart';

class LogoutModel extends LogoutEntity {
  const LogoutModel({
    required super.success,
    super.message,
    super.userId,
  });

  factory LogoutModel.fromJson(Map<String, dynamic> json) {
    return LogoutModel(
      success: json['success'] ?? false,
      message: json['message'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'user_id': userId,
    };
  }

  factory LogoutModel.fromEntity(LogoutEntity entity) {
    return LogoutModel(
      success: entity.success,
      message: entity.message,
      userId: entity.userId,
    );
  }
}