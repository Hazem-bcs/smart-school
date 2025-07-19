import 'package:core/data/models/subject_model.dart';
import 'package:core/network/dio_client.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../models/teatcher_model.dart';

abstract class TeacherRemoteDataSource {
  Future<Either<Failure, List<TeacherModel>>> getTeacherList(int studentId);

  Future<Either<Failure, TeacherModel>> getTeacherById(int teacherId);
}

class TeacherRemoteDataSourceImpl extends TeacherRemoteDataSource {
  final DioClient dioClient;

  TeacherRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, TeacherModel>> getTeacherById(int teacherId) async {
    // try {
    //   final response = await dioClient.post(
    //     Constants.getTeacherById,
    //     data: {'id': teacherId},
    //   );
    //   return Right(TeacherModel.fromJson(response.data));
    // } on DioException catch (e) {
    //   return Left(handleDioException(e));
    // } catch (e) {
    //   return Left(UnknownFailure(message: 'Unknown error occurred'));
    // }
    return Right(
      TeacherModel(
        id: 1,
        name: 'mazen',
        image: 'assets/images/user.png',
        description: 'good teacher_feat',
        phone: '0941321444',
        address: 'Middle City next to Jiva market',
        subjectList: [
          SubjectModel(
            id: 1,
            name: 'math',
            image:
                'https://cbx-prod.b-cdn.net/COLOURBOX60175808.jpg?width=800&height=800&quality=70',
          ),
          SubjectModel(
            id: 2,
            name: 'since',
            image:
                'https://cbx-prod.b-cdn.net/COLOURBOX60175808.jpg?width=800&height=800&quality=70',
          ),
          SubjectModel(
            id: 3,
            name: 'english',
            image:
                'https://cbx-prod.b-cdn.net/COLOURBOX60175808.jpg?width=800&height=800&quality=70',
          ),
        ],
      ),
    );
  }

  @override
  Future<Either<Failure, List<TeacherModel>>> getTeacherList(
    int studentId,
  ) async {
    // try {
    //   final response = await dioClient.post(
    //     Constants.getTeacherList,
    //     data: {'id': studentId},
    //   );
    //   return Right(TeacherModel.fromJson(response.data));
    // } on DioException catch (e) {
    //   return Left(handleDioException(e));
    // } catch (e) {
    //   return Left(UnknownFailure(message: 'Unknown error occurred'));
    // }

    print("Fetching data from API...");
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    final List<Map<String, dynamic>> dummyJson = [
      {
        "id": "1",
        "name": "Rama",
        "image": "https://safasfasf",
        "description": 'مدرسة مواد عدة لديها مهارات جيدة',
        "subjects": [
          {
            'id': 3,
            'name': 'علوم',
            'image':
                'https://images.unsplash.com/photo-1542831371-29b0f74f94dd?fit=crop&w=800&q=80',
          },
        ],
      },
      {
        "id": "2",
        "name": "ahmad",
        "image": "https://safasfasf",
        "description": 'مدرس مواد عدة لديه مهارات جيدة',
        "subjects": [
          {
            'id': 1,
            'name': 'رياضيات',
            'image':
                'https://images.unsplash.com/photo-1510904221195-ad9211c6d376?fit=crop&w=800&q=80',
          },
        ],
      },
      {
        "id": "3",
        "name": "mazen",
        "image": "https://safasfasf",
        "description": 'مدرس مواد عدة لديه مهارات جيدة',
        "subjects": [
          {
            'id': 1,
            'name': 'رياضيات',
            'image':
                'https://images.unsplash.com/photo-1554988775-8178120b08e2?fit=crop&w=800&q=80',
          },
          {
            'id': 2,
            'name': 'عربي',
            'image':
                'https://images.unsplash.com/photo-1554988775-8178120b08e2?fit=crop&w=800&q=80',
          },
        ],
      },
    ];
    return Right(dummyJson.map((json) => TeacherModel.fromJson(json)).toList());
  }
}
