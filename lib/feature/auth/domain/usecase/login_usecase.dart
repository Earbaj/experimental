
import 'package:untitled1/feature/auth/domain/entity/user_entity.dart';
import 'package:untitled1/feature/auth/domain/repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;
  LoginUseCase(this._authRepository);

  Future<UserEntity> call(String email, String password) {
    return _authRepository.login(email, password);
  }
}