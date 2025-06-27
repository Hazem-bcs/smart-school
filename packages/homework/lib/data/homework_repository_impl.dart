import 'package:core/network/failures.dart';
import 'package:core/network/network_info.dart';
import 'package:dartz/dartz.dart';
import '../domain/entites/homework_entity.dart';
import '../domain/entites/question_entity.dart';
import '../domain/homework_repository.dart';
import 'data_sources/home_work_local_data_source.dart';
import 'data_sources/homework_remote_data_source.dart';


class HomeworkRepositoryImpl implements HomeworkRepository {
  final HomeworkRemoteDataSource remoteDataSource;
  final HomeWorkLocalDataSource homeWorkLocalDataSource;
  final NetworkInfo networkInfo;

  HomeworkRepositoryImpl({required this.remoteDataSource,required this.homeWorkLocalDataSource,required this.networkInfo});

  @override
  Future<Either<Failure, List<HomeworkEntity>>> getHomeworks() async {
    if (await networkInfo.isConnected) {
      final studentId = await homeWorkLocalDataSource.getId();
      final result = await remoteDataSource.getHomeworks(studentId ?? 0);
      return result.fold(
              (failure) => left(failure),
              (homeWorkList) async {
                return Right(homeWorkList.map((ele) => ele.toEntity()).toList());
          }
      );
    } else {
      return Left(ConnectionFailure(message: 'Connection Error'));
    }
  }

  @override
  Future<Either<Failure, List<QuestionEntity>>> getListQuestionEntities(int questionId) async {
    if (await networkInfo.isConnected) {
      final result = await remoteDataSource.getQuestionList(questionId);
      return result.fold(
              (failure) => left(failure),
              (questionList) async {
            return Right(questionList.map((ele) => ele.toEntity()).toList());
          }
      );
    } else {
      return Left(ConnectionFailure(message: 'Connection Error'));
    }
  }

  @override
  Future<void> updateHomeworkStatus(int homeWork, int mark) async {
    // if (await networkInfo.isConnected) {
    //   final result = await remoteDataSource.getQuestionList(questionId);
    //   return result.fold(
    //           (failure) => left(failure),
    //           (questionList) async {
    //         return Right(questionList.map((ele) => ele.toEntity()).toList());
    //       }
    //   );
    // } else {
    //   return Left(ConnectionFailure(message: 'Connection Error'));
    // }
  }
}