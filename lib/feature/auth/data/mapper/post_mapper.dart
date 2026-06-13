import '../../domain/entity/post_entity.dart';
import '../../domain/entity/post_response_entity.dart';
import '../model/post_model.dart';
import '../model/post_response_model.dart';

class PostMapper {
  static PostResponseEntity toEntity(PostResponseModel model) {
    return PostResponseEntity(
      posts: model.posts.map((e) => _toPostEntity(e)).toList(),
      total: model.total,
      skip: model.skip,
      limit: model.limit,
    );
  }

  static PostEntity _toPostEntity(PostModel model) {
    return PostEntity(
      id: model.id,
      title: model.title,
      body: model.body,
      tags: model.tags,
      likes: model.likes,
      dislikes: model.dislikes,
      views: model.views,
      userId: model.userId,
    );
  }
}