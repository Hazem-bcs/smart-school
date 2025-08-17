import 'package:core/network/dio_client.dart';
import 'package:core/network/failures.dart';
import 'package:core/constant.dart';
import 'package:dartz/dartz.dart';

import '../models/due_model.dart';

// العقد
abstract class DuesRemoteDataSource {
  Future<Either<Failure, List<DueModel>>> getMyDues(int studentId);
}

// التنفيذ الفعلي مع Laravel backend
class DuesRemoteDataSourceImpl implements DuesRemoteDataSource {
  final DioClient dioClient;

  DuesRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, List<DueModel>>> getMyDues(int studentId) async {
    try {
      final response = await dioClient.post(
        Constants.getDuesEndpoint,
        data: {
          'id': 1,
        },
      );
      print('here responsereeeeeeeeeeeeeeeeeeeeeeeeeeeee');
      return response.fold(
        (failure) {
          print("❌ Failed to fetch dues: ${failure.message}");
          return Left(failure);
        },
        (response) {
          try {
            print("✅ Successfully received response from Laravel backend");
            print("📄 Response status: ${response.statusCode}");
            print("📄 Response data type: ${response.data.runtimeType}");
            print("📄 Response data: ${response.data}");
            
            // Parse the response data
            final data = response.data;
            if (data == null) {
              print("❌ Response data is null");
              return Left(UnknownFailure(message: 'Invalid response format: data is null'));
            }

            // Handle both array and object with data property
            List<dynamic> duesList;
            if (data is List) {
              print("📋 Response is a List with ${data.length} items");
              duesList = data;
            } else if (data is Map && data.containsKey('data')) {
              print("📋 Response is an Object with data property");
              final dataProperty = data['data'];
              if (dataProperty is List) {
                duesList = dataProperty;
                print("📋 Data property contains ${duesList.length} items");
              } else {
                print("❌ Data property is not a List: ${dataProperty.runtimeType}");
                return Left(UnknownFailure(message: 'Invalid response format: data property is not a List'));
              }
            } else {
              print("❌ Response format not recognized");
              print("❌ Expected List or Object with 'data' property, got: ${data.runtimeType}");
              return Left(UnknownFailure(message: 'Invalid response format: expected array or data property'));
            }

            // Convert to DueModel objects
            final dueModels = <DueModel>[];
            for (int i = 0; i < duesList.length; i++) {
              try {
                final dueJson = duesList[i] as Map<String, dynamic>;
                print("🔄 Parsing due item $i: $dueJson");
                final dueModel = DueModel.fromLaravelResponse(dueJson);
                dueModels.add(dueModel);
                print("✅ Successfully parsed due item $i");
              } catch (e) {
                print("❌ Error parsing due item $i: $e");
                print("❌ Due item data: ${duesList[i]}");
                return Left(UnknownFailure(message: 'Error parsing due item $i: ${e.toString()}'));
              }
            }

            print("📊 Successfully parsed ${dueModels.length} dues");
            return Right(dueModels);
          } catch (e) {
            print("❌ Error parsing dues response: $e");
            print("❌ Stack trace: ${StackTrace.current}");
            return Left(UnknownFailure(message: 'Error parsing response: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      print("❌ Unexpected error in getMyDues: $e");
      return Left(UnknownFailure(message: 'Unexpected error occurred: ${e.toString()}'));
    }
  }
}