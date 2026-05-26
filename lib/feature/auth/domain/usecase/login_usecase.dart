import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/user_entity.dart';
import '../repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(String email, String password) {
    return repository.signInWithEmailAndPassword(email, password);
  }
}
