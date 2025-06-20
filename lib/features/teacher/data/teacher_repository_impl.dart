import 'package:dartz/dartz.dart';
import 'package:smart_school/core/network/network_info.dart';

import '../../../../core/network/failures.dart';
import '../domain/teacher_entity.dart';
import '../domain/teatcher_repository.dart';
import 'data_sources/teacher_local_data_source.dart';
import 'data_sources/teacher_remote_data_source.dart';

class TeacherRepositoryImpl extends TeacherRepository {
  final TeacherRemoteDataSource remoteDataSource;
  final TeacherLocalDataSource teacherLocalDataSource;
  final NetworkInfo networkInfo;

  TeacherRepositoryImpl({required this.remoteDataSource,required this.teacherLocalDataSource,required this.networkInfo});
  @override
  Future<Either<Failure, TeacherEntity>> getTeacherById(int teacherId) async {
    if (await networkInfo.isConnected) {
      final result = await remoteDataSource.getTeacherById(teacherId);
      return result.fold(
              (failure) => left(failure),
              (teacherModel) async {
            return Right(teacherModel.toEntity());
          }
      );
    } else {
      return Left(ConnectionFailure(message: 'Connection Error'));
    }
  }

  @override
  Future<Either<Failure, List<TeacherEntity>>> getTeacherList() async {
    if (await networkInfo.isConnected) {
      final int studentId = await teacherLocalDataSource.getId() ?? 0;
      final result = await remoteDataSource.getTeacherList(studentId);
      return result.fold(
              (failure) => left(failure),
              (teacherList) async {
            return Right(teacherList.map((ele) => ele.toEntity()).toList());
          }
      );
    } else {
      return Left(ConnectionFailure(message: 'Connection Error'));
    }
  }
}