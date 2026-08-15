import '../entity/user_entity.dart';
import '../repository/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;
  SignUpUseCase(this.repository);

  Future<UserEntity> call({required String email, required String password}) {
    return repository.signUp(email: email, password: password);
  }
}