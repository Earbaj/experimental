import 'package:equatable/equatable.dart';
import 'package:untitled1/feature/auth/domain/entity/post_entity.dart';

class PostResponseEntity extends Equatable {
  final List<PostEntity> posts;
  final int total;
  final int skip;
  final int limit;

  const PostResponseEntity({
    required this.posts,
    required this.total,
    required this.skip,
    required this.limit,
  });

  @override
  List<Object?> get props => [posts, total, skip, limit];
}