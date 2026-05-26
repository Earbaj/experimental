import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  );

  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  );

  Future<Either<Failure, void>> signOut();

  Stream<UserEntity?> get authStateChanges;

  UserEntity? get currentUser;
}
