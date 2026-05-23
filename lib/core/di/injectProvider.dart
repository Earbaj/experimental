import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../feature/auth/data/datasource/location_local_data_source.dart';
import '../../feature/auth/data/datasource/location_remote_data_source.dart';
import '../../feature/auth/data/repositoryImpl/location_repository_impl.dart';
import '../../feature/auth/domain/repository/location_repository.dart';
import '../../feature/auth/domain/usecase/get_current_location_usecase.dart';
import '../../feature/auth/domain/usecase/start_tracking_usecase.dart';
import '../../feature/auth/domain/usecase/stop_tracking_usecase.dart';
import '../../feature/auth/presentation/block/location_tracking_bloc.dart';
import '../helper/database_helper.dart';
import '../network/network_info.dart';
import '../services/background_service.dart';
import '../services/permission_service.dart';

final sl = GetIt.instance;

Future<void> init() async {

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Services
  sl.registerLazySingleton(() => PermissionService());
  sl.registerLazySingleton(() => BackgroundService());

  // ১. External (এরা কারো ওপর নির্ভরশীল নয়)
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => DatabaseHelper());

  // Data Sources
  sl.registerLazySingleton<LocationLocalDataSource>(
        () => LocationLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<LocationRemoteDataSource>(
        () => LocationRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<LocationRepository>(() => LocationRepositoryImpl(
    localDataSource: sl(),
    remoteDataSource: sl(),
    networkInfo: sl(),
    permissionService: sl(),
    backgroundService: sl(),
  ));

  // Use Cases
  sl.registerLazySingleton(() => StartTrackingUseCase(sl()));
  sl.registerLazySingleton(() => StopTrackingUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentLocationUseCase(sl()));

  // BLoC
  sl.registerFactory(() => LocationTrackingBloc(
    startTrackingUseCase: sl(),
    stopTrackingUseCase: sl(),
    getCurrentLocationUseCase: sl(),
    locationRepository: sl(),
  ));

  // Initialize background service
  await sl<BackgroundService>().initialize();
}