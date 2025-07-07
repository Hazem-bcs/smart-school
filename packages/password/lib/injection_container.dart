import 'package:core/network/dio_client.dart';
import 'package:get_it/get_it.dart';

import 'data/datasources/password_remote_datasource.dart';
import 'data/repositories/password_repository_impl.dart';
import 'domain/repositories/password_repository.dart';
import 'domain/usecases/change_password_usecase.dart';
import 'presentation/blocs/password_bloc.dart';

Future<void> setupPasswordDependencies(GetIt getIt) async {
  // --------------------------  D A T A S O U R C E S   -----------------------------------
  getIt.registerSingleton<PasswordRemoteDataSource>(
    PasswordRemoteDataSourceImpl(getIt<DioClient>()),
  );

  // --------------------------  R E P O S I T O R Y   -----------------------------------
  getIt.registerSingleton<PasswordRepository>(
    PasswordRepositoryImpl(remoteDataSource: getIt<PasswordRemoteDataSource>()),
  );

  // --------------------------  U S E C A S E S   -----------------------------------
  getIt.registerFactory(() => ChangePasswordUseCase(getIt<PasswordRepository>()));

  // --------------------------  B L O C S   -----------------------------------
  getIt.registerFactory(() => PasswordBloc(changePasswordUseCase: getIt<ChangePasswordUseCase>()));
} 