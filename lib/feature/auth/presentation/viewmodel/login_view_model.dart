import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled1/feature/auth/domain/usecase/login_usecase.dart';

import '../../domain/repository/auth_repository.dart';
import '../state/login_state.dart';

class LoginViewModel extends StateNotifier<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginViewModel(this._loginUseCase) : super(LoginState());

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _loginUseCase(username, password);
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}