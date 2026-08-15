import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signUp({required String email, required String password});
  Future<UserEntity> login({required String email, required String password});
  Future<void> signOut();
  Stream<UserEntity?> get authStateChanges;
}
