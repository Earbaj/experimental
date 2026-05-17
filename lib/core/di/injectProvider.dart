import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../feature/auth/data/datasource/auth_remote_datasource.dart';
import '../../feature/auth/data/repositoryImpl/auth_repository_impl.dart';
import '../../feature/auth/domain/repository/auth_repository.dart';
import '../../feature/auth/domain/usecase/login_usecase.dart';
import '../../feature/auth/presentation/viewmodel/login_block.dart';
import '../config/dio_client.dart';
import '../storage/shared_prefs.dart';
import '../storage/token_storage.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ১. External (এরা কারো ওপর নির্ভরশীল নয়)
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // ২. Core / Network Clients (এরা External-এর ওপর নির্ভরশীল)
  // এখানে DioClient রেজিস্টার করা নিশ্চিত করুন এবং sl() দিয়ে Dio পাস করুন
  sl.registerLazySingleton(() => DioClient(sl()));

  // ৩. Data Layer (এরা Network বা Storage এর ওপর নির্ভরশীল)
  sl.registerLazySingleton<TokenStorage>(() => SharedPref(sl()));

  // এখানে AuthRemoteDataSource-এর ভেতর DioClient চলে যাবে sl() এর মাধ্যমে
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource(sl()));

  // Repo-এর ভেতর RemoteDataSource এবং TokenStorage যাবে
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(), sl()));

  // ৪. Domain Layer
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // ৫. Presentation Layer (Bloc)
  sl.registerFactory(() => LoginBloc(loginUseCase: sl()));
}