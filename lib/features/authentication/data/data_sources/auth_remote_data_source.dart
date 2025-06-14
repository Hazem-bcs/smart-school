import 'package:dio/dio.dart';

import '../../../../core/network/dio_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_modle.dart';


abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> validateToken(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dioClient.post(
        '/login',
        data: {'email': email, 'password': password},
      );
      // فقط بيانات وهمية لانو السيرفر مو شغال عنا
      return UserModel(email: 'admin123@gmail.com', password: '123455678', token: 'caxasdascxsafdsfvdsx');
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw handleDioException(e);
    }
  }

  @override
  Future<UserModel> validateToken(String token) async {
    try {
      final response = await dioClient.get(
        '/validate-token',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      rethrow;
    }
  }
}