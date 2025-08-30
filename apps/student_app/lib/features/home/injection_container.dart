import 'package:get_it/get_it.dart';
import 'data/datasources/home_remote_data_source.dart';
import 'data/repositories/home_repository_impl.dart';
import 'domain/repositories/home_repository.dart';
import 'domain/usecases/get_home_stats_usecase.dart';
import 'domain/usecases/get_quick_actions_usecase.dart';
import 'domain/usecases/get_achievements_usecase.dart';
import 'presentation/bloc/home_bloc.dart';

final sl = GetIt.instance;

Future<void> initHomeFeature() async {
  // Data sources
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetHomeStatsUseCase(sl()));
  sl.registerLazySingleton(() => GetQuickActionsUseCase(sl()));
  sl.registerLazySingleton(() => GetAchievementsUseCase(sl()));

  // BLoC
  sl.registerFactory(
    () => HomeBloc(
      getHomeStatsUseCase: sl(),
      getQuickActionsUseCase: sl(),
      getAchievementsUseCase: sl(),
    ),
  );
}
