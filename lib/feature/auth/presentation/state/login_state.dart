import 'package:untitled1/feature/auth/domain/entity/user_entity.dart';

class LoginState {
  final bool isLoading;
  final String? error;
  final UserEntity? user;

  LoginState(
      {this.isLoading=false, this.error,this.user});

  LoginState copyWith({bool? isLoading, String? error, UserEntity? user}) {
    return LoginState(
        isLoading: isLoading ?? this.isLoading,
        error: error,
        user: user ?? this.user
    );
  }
}
