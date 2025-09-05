import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import 'package:core/network/dio_client.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<Either<Failure, ProfileModel>> getProfile(int userId);
  Future<Either<Failure, ProfileModel>> updateProfile(ProfileModel profileModel);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient dioClient;

  ProfileRemoteDataSourceImpl({required this.dioClient});

  Either<Failure, ProfileModel> _parseWrappedObject(String jsonString) {
    try {
      final Map<String, dynamic> decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      final int status = decoded['status'] is int ? decoded['status'] as int : 500;
      if (status != 200) {
        final String message = decoded['message']?.toString() ?? 'حدث خطأ في الخادم';
        return Left(ServerFailure(message: message, statusCode: status));
      }
      final Map<String, dynamic> data = Map<String, dynamic>.from(decoded['data'] as Map);
      return Right(ProfileModel.fromJson(data));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileModel>> getProfile(int userId) async {
    // ********************************************************
    // API وهمي (JSON ثابت) وفق الاستجابة الموحدة { data, message, status }
    const String mockJson = '''
    {
      "data": {
        "id": "1",
        "name": "معلم تجريبي",
        "bio": "نبذة قصيرة عن المعلم",
        "avatarUrl": "https://example.com/avatar.jpg",
        "contactInfo": {
          "email": "teacher@school.com",
          "phone": "+1234567890"
        },
        "socialMedia": [
          { "platform": "X", "url": "X/teacher.com", "icon": "assets/icons/x_icon.svg" },
          { "platform": "Facebook", "url": "facebook/teacher.com", "icon": "assets/icons/facebook_icon.svg" }
        ],
        "professionalInfo": {
          "subjectsTaught": ["Mathematics", "Physics"],
          "gradeLevels": ["الصف العاشر", "الصف الحادي عشر"],
          "department": "الرياضيات",
          "qualifications": "ماجستير في الرياضيات التطبيقية",
          "certifications": "شهادة تدريس معتمدة"
        }
      },
      "message": "تم جلب البيانات بنجاح",
      "status": 200
    }
    ''';
    await Future.delayed(const Duration(milliseconds: 500));
    final fake = _parseWrappedObject(mockJson);
    if (fake.isRight()) return fake;
    // ********************************************************

    /*
    // الكتلة الحقيقية لاستدعاء الـ API (قم بإلغاء التعليق عند جاهزية الـ back-end)
    // final result = await dioClient.get('/profile/$userId');
    // return result.fold(
    //   (failure) => Left(failure),
    //   (response) {
    //     final data = response.data as Map<String, dynamic>?;
    //     final int status = data?['status'] is int ? data!['status'] as int : 500;
    //     if (status != 200) {
    //       final String message = data?['message']?.toString() ?? 'حدث خطأ غير متوقع';
    //       return Left(ServerFailure(message: message, statusCode: status));
    //     }
    //     final Map<String, dynamic> body = Map<String, dynamic>.from(data?['data'] as Map);
    //     return Right(ProfileModel.fromJson(body));
    //   },
    // );
    */

    return fake; // fallback على الوهمي لحين الجاهزية
  }

  @override
  Future<Either<Failure, ProfileModel>> updateProfile(ProfileModel profileModel) async {
    // ********************************************************
    // API وهمي (JSON ثابت) وفق الاستجابة الموحدة { data, message, status }
    final Map<String, dynamic> wrapped = {
      'data': profileModel.toJson(),
      'message': 'تم تحديث البيانات بنجاح',
      'status': 200,
    };
    await Future.delayed(const Duration(milliseconds: 400));
    final fake = _parseWrappedObject(jsonEncode(wrapped));
    if (fake.isRight()) return fake;
    // ********************************************************

    /*
    // الكتلة الحقيقية لاستدعاء الـ API (قم بإلغاء التعليق عند جاهزية الـ back-end)
    // final result = await dioClient.put('/profile/update', data: profileModel.toJson());
    // return result.fold(
    //   (failure) => Left(failure),
    //   (response) {
    //     final data = response.data as Map<String, dynamic>?;
    //     final int status = data?['status'] is int ? data!['status'] as int : 500;
    //     if (status != 200) {
    //       final String message = data?['message']?.toString() ?? 'فشل تحديث البيانات';
    //       return Left(ServerFailure(message: message, statusCode: status));
    //     }
    //     final Map<String, dynamic> body = Map<String, dynamic>.from(data?['data'] as Map);
    //     return Right(ProfileModel.fromJson(body));
    //   },
    // );
    */

    return fake; // fallback على الوهمي لحين الجاهزية
  }
}