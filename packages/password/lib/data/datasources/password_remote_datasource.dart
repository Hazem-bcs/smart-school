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
    // TODO: إعادة كتابة المنطق لاحقًا ليتعامل مع Either<Failure, Response>
    throw UnimplementedError('سيتم إعادة كتابة هذه الدالة لاحقًا');
  }
} 