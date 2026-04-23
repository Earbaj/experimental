import 'package:untitled1/feature/auth/data/model/user_model.dart';
import 'package:untitled1/feature/auth/domain/entity/user_entity.dart';

extension AuthUserMapper on UserModel {
  UserEntity toEntity() {
    return UserEntity(
        accessToken: accessToken,
        refreshToken: refreshToken,
        id: id,
        userName: userName,
        email: email,
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        image: image);
  }
}
