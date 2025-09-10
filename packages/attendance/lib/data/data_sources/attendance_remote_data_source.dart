import 'package:core/network/dio_client.dart';
import 'package:core/network/failures.dart';
import 'package:core/constant.dart';
import 'package:dartz/dartz.dart';
import '../models/attendance_model.dart';

abstract class AttendanceRemoteDataSource {
  Future<Either<Failure, List<MonthlyAttendanceModel>>> getMonthlyAttendance(int studentId, int year);
  Future<Either<Failure, AttendanceModel>> getAttendanceDetails(int studentId, int year, int month);
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final DioClient dioClient;

  const AttendanceRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, List<MonthlyAttendanceModel>>> getMonthlyAttendance(int studentId, int year) async {
    try {
      // TODO: Replace with real API when available
      await Future.delayed(const Duration(milliseconds: 400));

      final mockJson = [
        {"monthName": "يناير",   "attendanceCount": 0, "absenceCount": 0,  "monthNumber": 1},
        {"monthName": "فبراير",  "attendanceCount": 0, "absenceCount": 0,  "monthNumber": 2},
        {"monthName": "مارس",    "attendanceCount": 0, "absenceCount": 0,  "monthNumber": 3},
        {"monthName": "أبريل",   "attendanceCount": 0, "absenceCount": 0,  "monthNumber": 4},
        {"monthName": "مايو",    "attendanceCount": 0, "absenceCount": 0,  "monthNumber": 5},
        {"monthName": "يونيو",   "attendanceCount": 0, "absenceCount": 0,  "monthNumber": 6},
        {"monthName": "يوليو",   "attendanceCount": 0, "absenceCount": 0,  "monthNumber": 7},
        {"monthName": "أغسطس",  "attendanceCount": 0,  "absenceCount": 0,  "monthNumber": 8},
        {"monthName": "سبتمبر", "attendanceCount": 1, "absenceCount": 0,  "monthNumber": 9},
        {"monthName": "أكتوبر",  "attendanceCount": 0, "absenceCount": 0,  "monthNumber": 10},
        {"monthName": "نوفمبر",  "attendanceCount": 0, "absenceCount": 0,  "monthNumber": 11},
        {"monthName": "ديسمبر",  "attendanceCount": 0, "absenceCount": 0,  "monthNumber": 12},
      ];
      final list = mockJson
          .map<MonthlyAttendanceModel>((json) => MonthlyAttendanceModel.fromJson(json))
          .toList();
      return Right(list);
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to load monthly attendance: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, AttendanceModel>> getAttendanceDetails(int studentId, int year, int month) async {
    try {
      final responseEither = await dioClient.post(
        Constants.getAttendanceDetailsEndpoint,
        data: {
          'student_id': studentId,
          'year': year,
          'month': month,
        },
      );
      return responseEither.fold(
        (failure) => Left(failure),
        (response) {
          try {
            final data = response.data;
            final Map<String, dynamic> json = data is Map<String, dynamic> ? data : <String, dynamic>{};
            final model = AttendanceModel.fromJson(json);
            return Right(model);
          } catch (e) {
            return Left(UnknownFailure(message: 'Invalid attendance details format'));
          }
        },
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to load attendance details: ${e.toString()}'));
    }
  }
}