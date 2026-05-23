import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:untitled1/feature/auth/domain/usecase/check_location_permission_usecase.dart';
import 'package:untitled1/feature/auth/domain/usecase/get_location_stream_usecase.dart';
import 'package:untitled1/feature/auth/domain/usecase/get_saved_locations_usecase.dart';
import 'package:untitled1/feature/auth/domain/usecase/sync_offline_locations_usecase.dart';

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
  sl.registerLazySingleton(() => GetLocationStreamUseCase(sl()));
  sl.registerLazySingleton(() => SyncOfflineLocationsUseCase(sl()));
  sl.registerLazySingleton(() => GetSavedLocationsUseCase(sl()));
  sl.registerLazySingleton(() => CheckLocationPermissionUseCase(sl()));

  // BLoC
  sl.registerFactory(() => LocationTrackingBloc(
    startTrackingUseCase: sl(),
    stopTrackingUseCase: sl(),
    getCurrentLocationUseCase: sl(),
    getLocationStreamUseCase: sl(),
    syncOfflineLocationsUseCase: sl(),
    getSavedLocationsUseCase: sl(),
    checkPermissionUseCase: sl(),

  ));

  // Initialize background service
  await sl<BackgroundService>().initialize();
}