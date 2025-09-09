import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import 'package:core/network/dio_client.dart';
import 'package:core/constant.dart';
import 'package:path/path.dart' as p;
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<Either<Failure, ProfileModel>> getProfile(int userId);
  Future<Either<Failure, ProfileModel>> updateProfile({
    required int userId,
    required ProfileModel profileModel,
    String? imagePath,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient dioClient;

  ProfileRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, ProfileModel>> getProfile(int userId) async {
    final result = await dioClient.post(
      Constants.teacherProfileEndpoint,
      data: { 'teacher_id': userId },
    );
    return result.fold(
      (failure) => Left(failure),
      (response) {
        try {
          final Map<String, dynamic>? resp = response.data as Map<String, dynamic>?;
          final int status = resp?['status'] is int ? resp!['status'] as int : 500;
          if (status != 200) {
            final String message = resp?['message']?.toString() ?? 'حدث خطأ في الخادم';
            return Left(ServerFailure(message: message, statusCode: status));
          }
          final Map<String, dynamic> data = Map<String, dynamic>.from(resp?['data'] as Map);
          final model = _modelFromBackend(data);
          return Right(model);
        } catch (e) {
          return Left(UnknownFailure(message: e.toString()));
        }
      },
    );
  }

  @override
  Future<Either<Failure, ProfileModel>> updateProfile({
    required int userId,
    required ProfileModel profileModel,
    String? imagePath,
  }) async {
    try {
      final formMap = <String, dynamic>{
        'teacher_id': userId,
        'name_ar': profileModel.name,
        'email': profileModel.contactInfoModel.email,
        'phone': profileModel.contactInfoModel.phone,
        // If you have address in UI, map it here. Otherwise, omit (API allows partial).
        // 'address': someAddress,
      };

      if (imagePath != null && imagePath.isNotEmpty) {
        formMap['image'] = await MultipartFile.fromFile(
          imagePath,
          filename: p.basename(imagePath),
        );
      }

      final formData = FormData.fromMap(formMap);

      final result = await dioClient.post(
        Constants.updateTeacherProfileEndpoint,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return result.fold(
        (failure) => Left(failure),
        (response) {
          try {
            final Map<String, dynamic>? resp = response.data as Map<String, dynamic>?;
            final int status = resp?['status'] is int ? resp!['status'] as int : 500;
            if (status != 200) {
              final String message = resp?['message']?.toString() ?? 'فشل تحديث البيانات';
              return Left(ServerFailure(message: message, statusCode: status));
            }
            final Map<String, dynamic> data = Map<String, dynamic>.from(resp?['data'] as Map);
            final model = _modelFromBackend(data);
            return Right(model);
          } catch (e) {
            return Left(UnknownFailure(message: e.toString()));
          }
        },
      );
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  ProfileModel _modelFromBackend(Map<String, dynamic> raw) {
    final String id = (raw['id'] ?? '').toString();
    final String name = (raw['name'] ?? '').toString();
    final String email = (raw['email'] ?? '').toString();
    final String phone = (raw['phone'] ?? '').toString();
    final String avatar = (raw['image_url'] ?? '').toString();

    final List<String> subjects = (raw['subjects'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];

    // sections: [{ section: 'a', classroom: 'Twelfth Class' }]
    final List<String> gradeLevels = (raw['sections'] as List?)
            ?.map((e) => e is Map ? '${e['classroom'] ?? ''} - ${e['section'] ?? ''}'.trim() : e.toString())
            .toList() ??
        <String>[];

    return ProfileModel(
      id: id,
      name: name,
      bio: '',
      avatarUrl: avatar,
      contactInfoModel: ContactInfoModel(email: email, phone: phone),
      socialMediaModel: const <SocialMediaModel>[],
      professionalInfoModel: ProfessionalInfoModel(
        subjectsTaught: subjects,
        gradeLevels: gradeLevels,
        department: '',
        qualifications: '',
        certifications: '',
      ),
    );
  }
}