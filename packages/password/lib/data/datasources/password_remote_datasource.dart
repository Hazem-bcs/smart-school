import 'package:core/network/dio_client.dart';
import '../models/password_change_request_model.dart';

abstract class PasswordRemoteDataSource {
  Future<void> changePassword(PasswordChangeRequestModel request);
}

class PasswordRemoteDataSourceImpl implements PasswordRemoteDataSource {
  final DioClient dioClient;

  PasswordRemoteDataSourceImpl(this.dioClient);

  @override
  Future<void> changePassword(PasswordChangeRequestModel request) async {
    try {
      final response = await dioClient.post(
        '/api/auth/change-password',
        data: request.toJson(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to change password');
      }
    } catch (e) {
      if (e.toString().contains('400')) {
        throw Exception('Invalid current password');
      } else if (e.toString().contains('401')) {
        throw Exception('Unauthorized');
      } else {
        throw Exception('Network error: $e');
      }
    }
  }
} 