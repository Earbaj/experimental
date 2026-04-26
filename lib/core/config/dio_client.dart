import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../di/inject_provider.dart';

class DioClient {
  final Dio _dio;
  final Ref _ref; // রিভারপড রিফ দরকার টোকেন স্টোরেজ এক্সেস করতে

  DioClient(this._dio, this._ref) {
    _dio
      ..options.baseUrl = 'https://dummyjson.com'
      ..options.connectTimeout = const Duration(seconds: 15)
      ..options.receiveTimeout = const Duration(seconds: 15)
      ..options.responseType = ResponseType.json;

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // রিকোয়েস্ট পাঠানোর আগে মেমোরি বা স্টোরেজ থেকে টোকেন অ্যাড করুন
          final token = await _ref.read(tokenStorageProvider).getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // যদি ৪০১ এরর আসে এবং সেটা লগইন রিকোয়েস্ট না হয়
          if (e.response?.statusCode == 401) {
            final success = await _refreshToken();

            if (success) {
              // রিফ্রেশ সফল হলে আগের রিকোয়েস্টটি আবার পাঠান (Retry)
              return handler.resolve(await _retry(e.requestOptions));
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  // নতুন টোকেন পাওয়ার লজিক
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _ref.read(tokenStorageProvider).getRefreshToken();

      // নতুন একটি Dio ইন্সট্যান্স ব্যবহার করুন যাতে ইনফিনিট লুপ না হয়
      final response = await Dio().post(
        'https://dummyjson.com/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newToken = response.data['accessToken'];
        final newRefreshToken = response.data['refreshToken'];

        // নতুন টোকেন সেভ করুন
        await _ref.read(tokenStorageProvider).saveAccessToken(newToken);
        await _ref.read(tokenStorageProvider).saveRefreshToken(newRefreshToken);
        return true;
      }
    } catch (e) {
      // রিফ্রেশ ফেল করলে ইউজারকে লগআউট করিয়ে দিন
      //_ref.read(loginProvider.notifier).logout();
    }
    return false;
  }

  // আগের রিকোয়েস্টটি পুনরায় পাঠানোর মেথড
  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    // নতুন টোকেনটি হেডারে আপডেট করুন
    final token = await _ref.read(tokenStorageProvider).getAccessToken();
    options.headers?['Authorization'] = 'Bearer $token';

    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Dio get dio => _dio;
}