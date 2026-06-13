import 'dart:convert';

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

    final response = await client.dio.get('https://dummyjson.com/posts?limit=$limit&skip=$skip');

    if (response.statusCode == 200) {
      return PostResponseModel.fromJson(jsonDecode(response.data));
    } else {
      throw Exception('Failed to load posts from server');
    }
  }
}