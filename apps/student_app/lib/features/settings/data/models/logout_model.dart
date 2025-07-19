// lib/features/settings/data/models/logout_model.dart

import '../../domain/entities/logout_status_entity.dart';

class LogoutModel extends LogoutStatusEntity {
  const LogoutModel({required super.success});

  factory LogoutModel.fromJson(Map<String, dynamic> json) {
    // افترض أن الـ backend يرسل 'message' أو 'status'
    // أو ببساطة status code 200 يعني نجاح
    // هنا نفترض وجود مفتاح 'success' في JSON
    return LogoutModel(
      success: json['success'] ?? true, // إذا لم يكن هناك مفتاح 'success', افترض النجاح
    );
  }

  Map<String, dynamic> toJson() {
    // هذا ليس ضروريًا لعملية Logout عادةً لأننا لا نرسل هذا Model إلى backend
    return {
      'success': success,
    };
  }
}