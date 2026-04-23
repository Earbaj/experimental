import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:untitled1/core/storage/token_storage.dart';
import 'package:untitled1/feature/auth/domain/entity/user_entity.dart';

class SharedPref implements TokenStorage {

  final FlutterSecureStorage _secureStorage;

  // Keys
  static const _keyAccess = 'access_token';
  static const _keyRefresh = 'refresh_token';
  static const _keyUser = 'user_info';

  SharedPref(this._secureStorage);

  @override
  Future<void> clearAll() async {
   await _secureStorage.deleteAll();
  }

  @override
  Future<String?> getAccessToken() {
    return _secureStorage.read(key: _keyAccess);
  }

  @override
  Future<String?> getRefreshToken() {
    return _secureStorage.read(key: _keyRefresh);
  }

  @override
  Future<UserEntity?> getUserInfo() async {
    final userInfo = await _secureStorage.read(key: _keyUser);
    if (userInfo == null) return null;
    final userMap = jsonDecode(userInfo);
    return UserEntity(
        accessToken: "",
        refreshToken: "",
        id: userMap['id'],
        userName: userMap['username'],
        email: userMap['email'],
        firstName: "",
        lastName: "",
        gender: "",
        image: userMap['image']
    );
  }

  @override
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: _keyAccess, value: token);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _keyRefresh, value: token);
  }

  @override
  Future<void> saveUserInfo(UserEntity user) async {
    final userMap = {
      'id': user.id,
      'username': user.userName,
      'email': user.email,
      'image': user.image
    };
    await _secureStorage.write(key: _keyUser, value: jsonEncode(userMap));
  }
}