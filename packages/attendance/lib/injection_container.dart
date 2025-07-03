import 'package:core/network/dio_client.dart';
import 'package:get_it/get_it.dart';
import 'package:core/network/network_info.dart';
import 'data/attendance_repository_impl.dart';
import 'data/data_sources/attendance_remote_data_source.dart';
import 'domain/attendance_repository.dart';
import 'domain/usecases/get_monthly_attendance_use_case.dart';
import 'domain/usecases/get_attendance_details_use_case.dart';

Future<void> setupAttendanceDependencies(GetIt getIt) async {
  // Data sources
  getIt.registerLazySingleton<AttendanceRemoteDataSource>(
    () => AttendanceRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );

  // Repository
  getIt.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(
      remoteDataSource: getIt<AttendanceRemoteDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(
    () => GetMonthlyAttendanceUseCase(getIt<AttendanceRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetAttendanceDetailsUseCase(getIt<AttendanceRepository>()),
  );
} 