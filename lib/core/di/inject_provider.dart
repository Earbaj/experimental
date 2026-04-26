import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../feature/auth/data/datasource/auth_remote_datasource.dart';
import '../../feature/auth/data/repositoryImpl/auth_repository_impl.dart';
import '../../feature/auth/domain/repository/auth_repository.dart';
import '../../feature/auth/domain/usecase/login_usecase.dart';
import '../../feature/auth/presentation/state/login_state.dart';
import '../../feature/auth/presentation/viewmodel/login_view_model.dart';
import '../config/dio_client.dart';
import '../storage/shared_prefs.dart';
import '../storage/token_storage.dart';

// --- External & Core ---
final dioProvider = Provider((ref) => Dio());
final dioClientProvider = Provider((ref) => DioClient(ref.read(dioProvider),ref));
final flutterSecureStorageProvider = Provider((ref) => const FlutterSecureStorage());

// --- Data Layer ---
final tokenStorageProvider = Provider<TokenStorage>((ref) {
  final secureStorage = ref.watch(flutterSecureStorageProvider);
  return SharedPref(secureStorage); // Your implementation
});

// ADD THIS: Remote Data Source Provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.read(dioClientProvider));
});

// UPDATED: Repository now takes the RemoteDataSource
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.read(authRemoteDataSourceProvider), // Fixed the type mismatch here
    ref.read(tokenStorageProvider),
  );
});

// --- Domain Layer ---
// ADD THIS: UseCase Provider
final loginUseCaseProvider = Provider((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});

// --- Presentation Layer ---
// UPDATED: ViewModel now takes the UseCase instead of the Repository
final loginProvider = StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  return LoginViewModel(ref.read(loginUseCaseProvider));
});