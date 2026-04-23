
import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;

  DioClient(this._dio) {
    _dio
      ..options.baseUrl = 'https://dummyjson.com'
      ..options.connectTimeout = const Duration(seconds: 15)
      ..options.receiveTimeout = const Duration(seconds: 15)
      ..options.responseType = ResponseType.json;
  }

  Dio get dio => _dio;
}