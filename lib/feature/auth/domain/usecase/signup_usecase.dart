import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/user_entity.dart';
import '../repository/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(String email, String password, String name) {
    return repository.signUpWithEmailAndPassword(email, password, name);
  }
}
