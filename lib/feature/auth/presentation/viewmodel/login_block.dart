import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/feature/auth/domain/usecase/login_usecase.dart';

import '../event/login_event.dart';
import '../state/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;

  LoginBloc({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase,
        super(LoginState.initial()) {

    // ইভেন্ট রেজিস্টার করা
    on<LoginSubmittedEvent>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
      LoginSubmittedEvent event,
      Emitter<LoginState> emit,
      ) async {
    // ১. লোডিং স্টেট ইমিট করা
    emit(state.copyWith(isLoading: true, error: null));

    try {
      // ২. ইউজকেস কল করা
      final user = await _loginUseCase(event.username, event.password);
      // ৩. সাকসেস স্টেট ইমিট করা
      emit(state.copyWith(isLoading: false, user: user));
    } catch (e) {
      // ৪. এরর স্টেট ইমিট করা
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}

/// If we want to style like riverpod without Event than below code should work

/*
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
  LoginCubit(this._loginUseCase) : super(LoginState.initial());

  Future<void> login(String username, String password) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final user = await _loginUseCase(username, password);
      emit(state.copyWith(isLoading: false, user: user));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}*/
