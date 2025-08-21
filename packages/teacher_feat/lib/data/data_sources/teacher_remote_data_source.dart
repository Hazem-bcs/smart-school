import 'package:core/constant.dart';
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

  final List<TeacherModel> _dummyTeachers = [
    TeacherModel(
      id: 1,
      name: 'Rama',
      email: 'rama@example.com',
      specializationId: 1,
      genderId: 2,
      joiningDate: '2025-01-01',
      address: 'عنوان المدرس الأول',
      isLogged: 0,
      image: 'assets/images/user.png',
      description: 'مدرسة مواد عدة لديها مهارات جيدة',
      phone: '0911111111',
      subjectList: [
        SubjectModel(
          id: 3,
          name: 'علوم',
          image:
              'https://images.unsplash.com/photo-1542831371-29b0f74f94dd?fit=crop&w=800&q=80',
          teachers: [],
          notes: [],
        ),
      ],
    ),
    TeacherModel(
      id: 2,
      name: 'ahmad',
      email: 'ahmad@example.com',
      specializationId: 2,
      genderId: 1,
      joiningDate: '2025-01-02',
      address: 'عنوان المدرس الثاني',
      isLogged: 0,
      image: 'assets/images/user.png',
      description: 'مدرس مواد عدة لديه مهارات جيدة',
      phone: '0922222222',
      subjectList: [
        SubjectModel(
          id: 1,
          name: 'رياضيات',
          image:
              'https://images.unsplash.com/photo-1510904221195-ad9211c6d376?fit=crop&w=800&q=80',
          teachers: [],
          notes: [],
        ),
      ],
    ),
    TeacherModel(
      id: 3,
      name: 'mazen',
      email: 'mazen@example.com',
      specializationId: 3,
      genderId: 1,
      joiningDate: '2025-01-03',
      address: 'عنوان المدرس الثالث',
      isLogged: 0,
      image: 'assets/images/user.png',
      description: 'مدرس مواد عدة لديه مهارات جيدة',
      phone: '0933333333',
      subjectList: [
        SubjectModel(
          id: 1,
          name: 'رياضيات',
          image:
              'https://images.unsplash.com/photo-1554988775-8178120b08e2?fit=crop&w=800&q=80',
          teachers: [],
          notes: [],
        ),
        SubjectModel(
          id: 2,
          name: 'عربي',
          image:
              'https://images.unsplash.com/photo-1554988775-8178120b08e2?fit=crop&w=800&q=80',
          teachers: [],
          notes: [],
        ),
      ],
    ),
  ];

  @override
  Future<Either<Failure, TeacherModel>> getTeacherById(int teacherId) async {
    print("Fetching teacher with ID: $teacherId");
    try {
      final responseEither = await dioClient.post(
        Constants.getTeacherById,
        data: {'id': teacherId},
      );
      return responseEither.fold(
        (failure) => Left(failure),
        (response) {
          try {
            final teacher = TeacherModel.fromJson(response.data);
            return Right(teacher);
          } catch (e) {
            return Left(UnknownFailure(message: 'Invalid response format: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'Unknown error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<TeacherModel>>> getTeacherList(
    int studentId,
  ) async {
    print("Fetching teachers list for student ID: $studentId");
    try {
      final responseEither = await dioClient.post(
        Constants.getTeacherList,
        data: {'id': studentId},
      );
      print('responseEither + $responseEither');
      return responseEither.fold(
        (failure) => Left(failure),
        (response) {
          try {
            final List<dynamic> teachersData = response.data['data'];
            final teachers = teachersData
                .map((teacherJson) => TeacherModel.fromJson(teacherJson))
                .toList();
            print(teachers);
            
            return Right(teachers);
          } catch (e) {
            return Left(UnknownFailure(message: 'Invalid response format: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'Unknown error occurred: ${e.toString()}'));
    }
  }
}