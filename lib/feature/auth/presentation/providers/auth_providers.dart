// Firebase Instance Provider
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasource/auth_remote_data_source.dart';
import '../../data/repositoryImpl/auth_repository_impl.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/usecase/get_auth_state_usecase.dart';
import '../../domain/usecase/login_usecase.dart';
import '../../domain/usecase/sign_out_usecase.dart';
import '../../domain/usecase/sign_up_usecase.dart';
import '../viewmodel/auth_viewmodel.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

// Data Source Provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.watch(firebaseAuthProvider));
});

// Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));
});

// Use Cases Providers
final loginUseCaseProvider = Provider((ref) => LoginUseCase(ref.watch(authRepositoryProvider)));
final signUpUseCaseProvider = Provider((ref) => SignUpUseCase(ref.watch(authRepositoryProvider)));
final signOutUseCaseProvider = Provider((ref) => SignOutUseCase(ref.watch(authRepositoryProvider)));
final getAuthStateUseCaseProvider = Provider((ref) => GetAuthStateUseCase(ref.watch(authRepositoryProvider)));

// Auth State Changes Stream Provider
final authStateStreamProvider = StreamProvider<UserEntity?>((ref) {
  return ref.watch(getAuthStateUseCaseProvider).call();
});

// Auth View Model / State Notifier Provider
final authControllerProvider = StateNotifierProvider<AuthViewModel, AsyncValue<void>>((ref) {
  return AuthViewModel(
    loginUseCase: ref.watch(loginUseCaseProvider),
    signUpUseCase: ref.watch(signUpUseCaseProvider),
    signOutUseCase: ref.watch(signOutUseCaseProvider),
  );
});