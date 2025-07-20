import 'package:get_it/get_it.dart';
import 'data/data_sources/schedule_remote_data_source.dart';
import 'data/repositories/schedule_repository_impl.dart';
import 'domain/repositories/schedule_repository.dart';
import 'domain/usecases/get_schedule_for_date_usecase.dart';
import 'presentation/blocs/schedule_bloc.dart';

final sl = GetIt.instance;

Future<void> initScheduleDependencies() async {
  // Data Sources
  sl.registerLazySingleton<ScheduleRemoteDataSource>(
    () => ScheduleRemoteDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetScheduleForDateUseCase(sl()));

  // BLoCs
  sl.registerFactory(() => ScheduleBloc(
    getScheduleForDateUseCase: sl(),
  ));
} 