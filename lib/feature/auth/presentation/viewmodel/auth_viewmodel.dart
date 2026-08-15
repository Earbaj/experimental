import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecase/login_usecase.dart';
import '../../domain/usecase/sign_out_usecase.dart';
import '../../domain/usecase/sign_up_usecase.dart';

class AuthViewModel extends StateNotifier<AsyncValue<void>> {
  final LoginUseCase _loginUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;

  AuthViewModel({
    required LoginUseCase loginUseCase,
    required SignUpUseCase signUpUseCase,
    required SignOutUseCase signOutUseCase,
  })  : _loginUseCase = loginUseCase,
        _signUpUseCase = signUpUseCase,
        _signOutUseCase = signOutUseCase,
        super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _loginUseCase(email: email, password: password);
      state = const AsyncValue.data(null);
    } on Failure catch (e, stack) {
      state = AsyncValue.error(e.message, stack);
    }
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _signUpUseCase(email: email, password: password);
      state = const AsyncValue.data(null);
    } on Failure catch (e, stack) {
      state = AsyncValue.error(e.message, stack);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _signOutUseCase();
      state = const AsyncValue.data(null);
    } on Failure catch (e, stack) {
      state = AsyncValue.error(e.message, stack);
    }
  }
}