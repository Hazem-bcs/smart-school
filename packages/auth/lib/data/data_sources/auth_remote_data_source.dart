import 'package:core/data/models/user_modle.dart';
import 'package:core/network/dio_client.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';



abstract class AuthRemoteDataSource {
  Future<Either<Failure, UserModel>> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, UserModel>> login(String email, String password) async {
    // مؤقتاً: أرجع بيانات وهمية
    final user = UserModel(
      id: 1,
      name: 'Test User',
      email: email,
      password: password,
      profilePhotoUrl: 'https://example.com/avatar.png',
      token: 'mock_token_123',
    );
    await Future.delayed(const Duration(milliseconds: 500));
    return Right(user);
    // عند توفر السيرفر أعد الكود الأصلي:
    /*
    try {
      final response = await dioClient.post(
        Constants.loginEndpoint,
        data: {'email': email, 'password': password},
      );
      return Right(UserModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(handleDioException(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'Unknown error occurred'));
    }
    */
  }
}