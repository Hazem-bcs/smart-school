import 'package:core/data/models/user_modle.dart';
import 'package:core/network/dio_client.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';




abstract class ProfileRemoteDataSource {
  Future<Either<Failure, UserModel>> getProfileData(int studentId);

}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient dioClient;

  ProfileRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, UserModel>> getProfileData(int studentId) async {
    // try {
    //   final response = await dioClient.post(
    //     Constants.getProfileData,
    //     data: {'student_id': studentId},
    //   );
    //   return Right(UserModel.fromJson(response.data));
    // } on DioException catch (e) {
    //   return Left(handleDioException(e));
    // } catch (e) {
    //   return Left(UnknownFailure(message: 'Unknown error occurred'));
    // }

    return Right(UserModel(id: studentId, name: 'mazen', email: 'mazen@gmail.com', password: '00000000', profilePhotoUrl: "assets/images/user_3.png", token: 'asdasdadas'));
  }
}