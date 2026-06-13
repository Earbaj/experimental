import 'package:untitled1/feature/auth/data/model/post_model.dart';

class PostResponseModel {
  final List<PostModel> posts;
  final int total;
  final int skip;
  final int limit;

  PostResponseModel({
    required this.posts,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory PostResponseModel.fromJson(Map<String, dynamic> json) {
    return PostResponseModel(
      posts: (json['posts'] as List? ?? [])
          .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] ?? 0,
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 0,
    );
  }
}