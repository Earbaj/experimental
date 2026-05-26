import '../entity/user_entity.dart';
import '../repository/auth_repository.dart';

class GetAuthStateStreamUseCase {
  final AuthRepository repository;

  GetAuthStateStreamUseCase(this.repository);

  Stream<UserEntity?> call() {
    return repository.authStateChanges;
  }
}
