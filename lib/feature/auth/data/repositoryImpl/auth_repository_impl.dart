
import 'package:untitled1/core/storage/token_storage.dart';
import 'package:untitled1/feature/auth/data/datasource/auth_remote_datasource.dart';
import 'package:untitled1/feature/auth/data/mapper/auth_user_mapper.dart';
import 'package:untitled1/feature/auth/domain/entity/user_entity.dart';
import 'package:untitled1/feature/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final TokenStorage _tokenStorage;
  AuthRepositoryImpl(this._remoteDataSource,this._tokenStorage);
  @override
  Future<UserEntity> login(String email, String password) async {
    final res = await _remoteDataSource.login(email, password);
    await _tokenStorage.saveAccessToken(res.accessToken!);
    await _tokenStorage.saveRefreshToken(res.refreshToken!);
    await _tokenStorage.saveUserInfo(res.toEntity());
    return res.toEntity();
  }

}