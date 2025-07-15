import 'package:core/network/dio_client.dart';
import 'package:dio/dio.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile(ProfileModel profile);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient dioClient;

  ProfileRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<ProfileModel> getProfile() async {
    // TODO: إعادة كتابة المنطق لاحقًا ليتعامل مع Either<Failure, Response>
    throw UnimplementedError('سيتم إعادة كتابة هذه الدالة لاحقًا');
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    // TODO: إعادة كتابة المنطق لاحقًا ليتعامل مع Either<Failure, Response>
    throw UnimplementedError('سيتم إعادة كتابة هذه الدالة لاحقًا');
  }
} 