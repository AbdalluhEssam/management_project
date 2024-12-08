// injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import '../../Features/auth/data/data_sources/user_remote_data_source.dart';
import '../../Features/auth/data/repositories/user_repository_impl.dart';
import '../../Features/auth/domain/repositories/user_repository.dart';
import '../../Features/auth/domain/use_cases/create_user_usecase.dart';
import '../../Features/auth/presentation/manager/user_cubit.dart';


final sl = GetIt.instance; // 'sl' stands for Service Locator

void setupInjection() {
  // Register external libraries
  sl.registerLazySingleton<Dio>(() => Dio());

  // Register data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
          () => UserRemoteDataSourceImpl(sl<Dio>()));

  // Register repositories
  sl.registerLazySingleton<UserRepository>(
          () => UserRepositoryImpl(sl<UserRemoteDataSource>()));

  // Register use cases
  sl.registerLazySingleton(() => CreateUser(sl<UserRepository>()));

  // Register cubits
  sl.registerFactory(() => UserCubit(sl<CreateUser>()));
}
