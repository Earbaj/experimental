import 'package:flutter_riverpod/legacy.dart';
import '../../domain/usecase/get_posts_usecase.dart';
import '../state/post_state.dart';

class PostViewModel extends StateNotifier<PostState> {
  final GetPostsUseCase getPostsUseCase;
  static const int _limit = 10;

  // Initial State সেট করছি
  PostViewModel({required this.getPostsUseCase}) : super(const PostState());

  Future<void> fetchPosts() async {
    // ১. যদি অলরেডি সব ডেটা চলে আসে, তবে আর এপিআই কল করব না
    if (state.hasReachedMax) return;

    // ২. প্রথমবার কল হলে লোডিং স্টেট দেখাব
    if (state.status == PostStatus.initial) {
      state = state.copyWith(status: PostStatus.loading);
    }

    // ৩. UseCase কল
    final result = await getPostsUseCase(
      GetPostsParams(limit: _limit, skip: state.currentSkip),
    );

    // ৪. dartz-এর fold দিয়ে স্টেট আপডেট
    result.fold(
          (failure) {
        state = state.copyWith(
          status: PostStatus.failure,
          errorMessage: failure.message,
        );
      },
          (response) {
        final newPosts = state.posts + response.posts;
        final hasReachedMax = newPosts.length >= response.total;

        state = state.copyWith(
          status: PostStatus.success,
          posts: newPosts,
          hasReachedMax: hasReachedMax,
          currentSkip: state.currentSkip + _limit,
        );
      },
    );
  }
}
