import 'package:equatable/equatable.dart';

import '../../domain/entity/post_entity.dart';

enum PostStatus { initial, loading, success, failure }

class PostState extends Equatable {
  final PostStatus status;
  final List<PostEntity> posts;
  final bool hasReachedMax;
  final String errorMessage;
  final int currentSkip;

  const PostState({
    this.status = PostStatus.initial,
    this.posts = const [],
    this.hasReachedMax = false,
    this.errorMessage = '',
    this.currentSkip = 0,
  });

  PostState copyWith({
    PostStatus? status,
    List<PostEntity>? posts,
    bool? hasReachedMax,
    String? errorMessage,
    int? currentSkip,
  }) {
    return PostState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
      currentSkip: currentSkip ?? this.currentSkip,
    );
  }

  @override
  List<Object?> get props => [status, posts, hasReachedMax, errorMessage, currentSkip];
}