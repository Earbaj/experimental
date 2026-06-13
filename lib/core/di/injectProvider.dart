import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../feature/auth/data/datasource/post_remote_data_source.dart';
import '../../feature/auth/data/repositoryImpl/post_repository_impl.dart';
import '../../feature/auth/domain/repository/post_repository.dart';
import '../../feature/auth/domain/usecase/get_posts_usecase.dart';
import '../../feature/auth/presentation/block/post_bloc.dart';
import '../config/dio_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ১. External (এরা কারো ওপর নির্ভরশীল নয়)
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // ২. Core / Network Clients (এরা External-এর ওপর নির্ভরশীল)
  // এখানে DioClient রেজিস্টার করা নিশ্চিত করুন এবং sl() দিয়ে Dio পাস করুন
  sl.registerLazySingleton(() => DioClient(sl()));

  // Repositories
  sl.registerLazySingleton<PostRepository>(() => PostRepositoryImpl(sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetPostsUseCase(sl()));

  // Data Sources
  sl.registerLazySingleton<PostRemoteDataSource>(() => PostRemoteDataSourceImpl(sl()));

  // BLoC / Presentation Layer
  sl.registerFactory(() => PostBloc(sl()));

}