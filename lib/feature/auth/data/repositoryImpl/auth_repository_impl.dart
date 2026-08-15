import '../../domain/entity/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasource/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> signUp({required String email, required String password}) async {
    final credential = await remoteDataSource.signUp(email, password);
    final user = credential.user!;
    return UserEntity(uid: user.uid, email: user.email ?? '');
  }

  @override
  Future<UserEntity> login({required String email, required String password}) async {
    final credential = await remoteDataSource.login(email, password);
    final user = credential.user!;
    return UserEntity(uid: user.uid, email: user.email ?? '');
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return remoteDataSource.authStateChanges.map((user) {
      if (user == null) return null;
      return UserEntity(uid: user.uid, email: user.email ?? '');
    });
  }
}