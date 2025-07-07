import '../../domain/entities/password_change_request.dart';

class PasswordChangeRequestModel extends PasswordChangeRequest {
  const PasswordChangeRequestModel({
    required super.currentPassword,
    required super.newPassword,
    required super.confirmPassword,
  });

  factory PasswordChangeRequestModel.fromEntity(PasswordChangeRequest entity) {
    return PasswordChangeRequestModel(
      currentPassword: entity.currentPassword,
      newPassword: entity.newPassword,
      confirmPassword: entity.confirmPassword,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }

  factory PasswordChangeRequestModel.fromJson(Map<String, dynamic> json) {
    return PasswordChangeRequestModel(
      currentPassword: json['currentPassword'] as String,
      newPassword: json['newPassword'] as String,
      confirmPassword: json['confirmPassword'] as String,
    );
  }
} 