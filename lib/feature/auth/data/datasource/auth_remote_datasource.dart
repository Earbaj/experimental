
import 'package:dio/dio.dart';
import 'package:untitled1/feature/auth/data/model/user_model.dart';

import '../../../../core/config/dio_client.dart';

class AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSource(this._dioClient);

  Future<UserModel> login(String username, String password) async {
    try {
      final response = await _dioClient.dio.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception("Failed to login");
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? "Connection Error");
    }
  }
}