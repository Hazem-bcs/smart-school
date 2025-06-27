import 'package:core/network/dio_client.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../models/due_model.dart';

// العقد
abstract class DuesRemoteDataSource {
  Future<Either<Failure,List<DueModel>>> getMyDues(int studentId);
}

// التنفيذ الفعلي (ببيانات وهمية كمثال)
class DuesRemoteDataSourceImpl implements DuesRemoteDataSource {
  final DioClient dioClient;

  DuesRemoteDataSourceImpl({required this.dioClient});
  @override
  Future<Either<Failure,List<DueModel>>> getMyDues(int studentId) async {
  //   try {
  //     final response = await dioClient.post(
  //       Constants.loginEndpoint,
  //       data: {'email': email, 'password': password},
  //     );
  //     return Right(UserModel.fromJson(response.data));
  //   } on DioException catch (e) {
  //     return Left(handleDioException(e));
  //   } catch (e) {
  //     return Left(UnknownFailure(message: 'Unknown error occurred'));
  //   }
  // }
    print("Fetching dues for the student from remote source...");
    await Future.delayed(const Duration(seconds: 1)); // محاكاة تأخير الشبكة

    // بيانات وهمية كمثال
    return Right([
      DueModel(id: '1', description: 'رسوم الفصل الدراسي الأول', amount: 850000, dueDate: DateTime(2025, 9, 15), isPaid: true),
      DueModel(id: '2', description: 'رسوم السكن الجامعي (شهر أكتوبر)', amount: 150000, dueDate: DateTime(2025, 10, 5), isPaid: false),
      DueModel(id: '3', description: 'رسوم المواصلات', amount: 100000, dueDate: DateTime(2025, 9, 10), isPaid: true),
      DueModel(id: '4', description: 'غرامة تأخير كتاب', amount: 25000, dueDate: DateTime(2025, 11, 1), isPaid: false),
    ]);
  }
}