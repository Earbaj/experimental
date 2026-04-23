
import '../../feature/auth/domain/entity/user_entity.dart';

abstract class TokenStorage {
  Future<void> saveAccessToken(String token);
  Future<void> saveRefreshToken(String token);
  Future<void> saveUserInfo(UserEntity user); // For profile info

  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<UserEntity?> getUserInfo();

  Future<void> clearAll();
}