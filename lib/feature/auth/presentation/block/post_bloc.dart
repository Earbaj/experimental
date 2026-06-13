import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/get_posts_usecase.dart';
import '../event/post_event.dart';
import '../state/post_state.dart';


class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPostsUseCase getPostsUseCase;
  static const int _limit = 10; // Set pagination chunk limit

  PostBloc(this.getPostsUseCase) : super(const PostState()) {
    on<FetchPostsEvent>(_onFetchPosts);
  }

  Future<void> _onFetchPosts(FetchPostsEvent event, Emitter<PostState> emit) async {
    if (state.hasReachedMax) return;

    if (state.status == PostStatus.initial) {
      emit(state.copyWith(status: PostStatus.loading));
    }

    final result = await getPostsUseCase(
      GetPostsParams(limit: _limit, skip: state.currentSkip),
    );

    result.fold(
          (failure) => emit(state.copyWith(status: PostStatus.failure, errorMessage: failure.message)),
          (response) {
        final newPosts = state.posts + response.posts;
        final hasReachedMax = newPosts.length >= response.total;

        emit(state.copyWith(
          status: PostStatus.success,
          posts: newPosts,
          hasReachedMax: hasReachedMax,
          currentSkip: state.currentSkip + _limit,
        ));
      },
    );
  }
}