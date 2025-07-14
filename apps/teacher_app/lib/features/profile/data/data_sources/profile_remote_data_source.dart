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
    try {
      final response = await dioClient.get('/profile');
      
      if (response.statusCode == 200) {
        return ProfileModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load profile: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load profile: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    try {
      final response = await dioClient.put(
        '/profile',
        data: profile.toJson(),
      );
      
      if (response.statusCode == 200) {
        return ProfileModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to update profile: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update profile: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
} 