import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/dio_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ১. External (এরা কারো ওপর নির্ভরশীল নয়)
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // ২. Core / Network Clients (এরা External-এর ওপর নির্ভরশীল)
  // এখানে DioClient রেজিস্টার করা নিশ্চিত করুন এবং sl() দিয়ে Dio পাস করুন
  sl.registerLazySingleton(() => DioClient(sl()));

  // ৩. Data Layer (এরা Network বা Storage এর ওপর নির্ভরশীল)

  // এখানে AuthRemoteDataSource-এর ভেতর DioClient চলে যাবে sl() এর মাধ্যমে

  // Repo-এর ভেতর RemoteDataSource এবং TokenStorage যাবে

  // ৪. Domain Layer

  // ৫. Presentation Layer (Bloc)

}