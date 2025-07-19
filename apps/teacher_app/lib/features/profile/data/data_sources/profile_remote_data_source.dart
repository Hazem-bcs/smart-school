import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<Either<Failure, ProfileModel>> getProfile(int userId);
  Future<Either<Failure, ProfileModel>> updateProfile(ProfileModel profileModel);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  @override
  Future<Either<Failure, ProfileModel>> getProfile(int userId) async {
    // ملاحظة: الكود التالي وهمي فقط، عند الربط مع الـ backend استبدله بطلب فعلي
    await Future.delayed(const Duration(milliseconds: 800));
    final Map<String, dynamic> response = {
      'success': true,
      'statuscode': 200,
      'data': {
        'id': userId.toString(),
        'name': 'معلم تجريبي',
        'bio': 'نبذة عن المعلم ...',
        'contactInfo': {
          'email': 'teacher@school.com',
          'phone': '+1234567890',
        },
        'avatarUrl': 'https://example.com/avatar.jpg',
        'socialMedia': [
          {
            'platform': 'X',
            'url': 'X/teacher.com',
            'icon': 'assets/icons/x_icon.svg',
          },
          {
            'platform': 'Facebook',
            'url': 'facebook/teacher.com',
            'icon': 'assets/icons/facebook_icon.svg',
          },
          {
            'platform': 'Instagram',
            'url': 'instagram/teacher.com',
            'icon': 'assets/icons/instagram_icon.svg',
          },
        ],
        'professionalInfo': {
          'subjectsTaught': ['Mathematics', 'Physics'],
          'gradeLevels': ['الصف العاشر', 'الصف الحادي عشر', 'الصف الثاني عشر'],
          'department': 'الرياضيات',
          'qualifications': 'ماجستير في الرياضيات التطبيقية',
          'certifications': 'شهادة تدريس معتمدة من وزارة التربية والتعليم',
        },
      },
      'message': 'تم جلب البيانات بنجاح',
    };

    if (response['success'] == true && response['statuscode'] == 200) {
      final profile = ProfileModel.fromJson(response['data']);
      return Right(profile);
    } else {
      return Left(ServerFailure(message: response['message'] ?? 'خطأ غير معروف'));
    }
  }

  @override
  Future<Either<Failure, ProfileModel>> updateProfile(ProfileModel profileModel) async {
    final Map<String, dynamic> response = {
      'success': true,
      'statuscode': 200,
      'data': profileModel.toJson(),
      'message': 'تم تحديث البيانات بنجاح',
    };

    if (response['success'] == true && response['statuscode'] == 200) {
      final updatedProfile = ProfileModel.fromJson(response['data']);
      return Right(updatedProfile);
    } else {
      return Left(ServerFailure(message: response['message'] ?? 'خطأ غير معروف'));
    }
  }
} 