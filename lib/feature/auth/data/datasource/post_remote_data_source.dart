import 'dart:convert';
import 'dart:developer';

import 'package:untitled1/core/config/dio_client.dart';

import '../model/post_response_model.dart';


abstract class PostRemoteDataSource {
  Future<PostResponseModel> fetchPosts({required int limit, required int skip});
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final DioClient client;
  const PostRemoteDataSourceImpl(this.client);

  @override
  Future<PostResponseModel> fetchPosts({required int limit, required int skip}) async {
    try {
      final response = await client.dio.get(
        'https://dummyjson.com/posts?limit=$limit&skip=$skip',
      );

      if (response.statusCode == 200) {
        // 💡 DIO ALREADY PARSED THIS! response.data is a Map<String, dynamic>
        final data = response.data;

        if (data is Map<String, dynamic>) {
          return PostResponseModel.fromJson(data);
        } else {
          throw Exception('Expected Map from Dio but got: ${data.runtimeType}');
        }
      } else {
        throw Exception('Failed to load posts from server: Status ${response.statusCode}');
      }
    } catch (error, stackTrace) {
      log("============== 🚨 DETAILED REPO/DIO ERROR 🚨 ==============");
      log("Exception Message: $error");
      log("------------------------------------------------------------");
      log("Stack Trace:");
      log(stackTrace.toString());
      log("=============================================================");
      rethrow;
    }
  }
}