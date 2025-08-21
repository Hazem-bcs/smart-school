import 'package:core/network/dio_client.dart';
import '../models/attendance_model.dart';

abstract class AttendanceRemoteDataSource {
  Future<List<MonthlyAttendanceModel>> getMonthlyAttendance(int year);
  Future<AttendanceModel> getAttendanceDetails(int year, int month);
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final DioClient dioClient;

  const AttendanceRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<MonthlyAttendanceModel>> getMonthlyAttendance(int year) async {
    try {
      // TODO: Replace with actual API endpoint
      // final response = await dio.get('/attendance/monthly/$year');
      // return (response.data as List)
      //     .map((json) => MonthlyAttendanceModel.fromJson(json))
      //     .toList();

      // Mock data for now
      await Future.delayed(const Duration(milliseconds: 500));

      return [
        const MonthlyAttendanceModel(monthName: 'January', attendanceCount: 15, absenceCount: 16, monthNumber: 1),
        const MonthlyAttendanceModel(monthName: 'February', attendanceCount: 20, absenceCount: 8, monthNumber: 2),
        const MonthlyAttendanceModel(monthName: 'March', attendanceCount: 22, absenceCount: 9, monthNumber: 3),
        const MonthlyAttendanceModel(monthName: 'April', attendanceCount: 24, absenceCount: 6, monthNumber: 4),
        const MonthlyAttendanceModel(monthName: 'May', attendanceCount: 25, absenceCount: 6, monthNumber: 5),
        const MonthlyAttendanceModel(monthName: 'June', attendanceCount: 25, absenceCount: 5, monthNumber: 6),
        const MonthlyAttendanceModel(monthName: 'July', attendanceCount: 26, absenceCount: 5, monthNumber: 7),
      ];
    } catch (e) {
      throw Exception('Failed to load monthly attendance: $e');
    }
  }

  @override
  Future<AttendanceModel> getAttendanceDetails(int year, int month) async {
    try {
      // TODO: Replace with actual API endpoint
      // final response = await dio.get('/attendance/details/$year/$month');
      // return AttendanceModel.fromJson(response.data);

      // Mock data for now
      await Future.delayed(const Duration(milliseconds: 500));
      return const AttendanceModel(
        year: 2025,
        month: 1,
        attendanceCount: 25,
        absenceCount: 3,
        presentDays: [1, 2, 3, 4, 6, 7, 9, 10, 11, 12, 14, 15, 16, 17, 18, 19, 21, 22, 23, 24, 25, 26, 28, 29, 30],
        absentDays: [5, 13, 27],
      );
    } catch (e) {
      throw Exception('Failed to load attendance details: $e');
    }
  }
}