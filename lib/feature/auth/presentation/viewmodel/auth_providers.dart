import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasource/auth_remote_data_source.dart';
import '../../data/repositoryImpl/auth_repository_impl.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/usecase/get_auth_state_stream_usecase.dart';
import '../../domain/usecase/get_current_user_usecase.dart';
import '../../domain/usecase/login_usecase.dart';
import '../../domain/usecase/logout_usecase.dart';
import '../../domain/usecase/signup_usecase.dart';

// Firebase Auth Instance Provider
final firebaseAuthProvider = Provider<fb.FirebaseAuth>((ref) {
  return fb.FirebaseAuth.instance;
});

// Remote Data Source Provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.watch(firebaseAuthProvider));
});

// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));
});

// Use Case Providers
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  return SignUpUseCase(ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(ref.watch(authRepositoryProvider));
});

final getAuthStateStreamUseCaseProvider = Provider<GetAuthStateStreamUseCase>((ref) {
  return GetAuthStateStreamUseCase(ref.watch(authRepositoryProvider));
});

// Authentication Stream Provider
final authStateChangesProvider = StreamProvider<UserEntity?>((ref) {
  final getAuthStateStream = ref.watch(getAuthStateStreamUseCaseProvider);
  return getAuthStateStream();
});
