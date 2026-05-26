import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entity/user_entity.dart';
import 'auth_providers.dart';

class AuthViewModel extends AsyncNotifier<UserEntity?> {
  @override
  FutureOr<UserEntity?> build() {
    final getCurrentUser = ref.read(getCurrentUserUseCaseProvider);
    return getCurrentUser();
  }

  Future<void> login(
    String email,
    String password, {
    void Function(String)? onError,
    void Function()? onSuccess,
  }) async {
    state = const AsyncValue.loading();
    final result = await ref.read(loginUseCaseProvider)(email, password);
    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        if (onError != null) onError(failure.message);
      },
      (user) {
        state = AsyncValue.data(user);
        if (onSuccess != null) onSuccess();
      },
    );
  }

  Future<void> signUp(
    String email,
    String password,
    String name, {
    void Function(String)? onError,
    void Function()? onSuccess,
  }) async {
    state = const AsyncValue.loading();
    final result = await ref.read(signUpUseCaseProvider)(email, password, name);
    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        if (onError != null) onError(failure.message);
      },
      (user) {
        state = AsyncValue.data(user);
        if (onSuccess != null) onSuccess();
      },
    );
  }

  Future<void> logout({
    void Function(String)? onError,
    void Function()? onSuccess,
  }) async {
    state = const AsyncValue.loading();
    final result = await ref.read(logoutUseCaseProvider)();
    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        if (onError != null) onError(failure.message);
      },
      (_) {
        state = const AsyncValue.data(null);
        if (onSuccess != null) onSuccess();
      },
    );
  }
}

// Global Auth View Model Provider
final authViewModelProvider = AsyncNotifierProvider<AuthViewModel, UserEntity?>(() {
  return AuthViewModel();
});
