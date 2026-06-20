import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/add_post_usecase.dart';
import '../event/add_post_event.dart';
import '../state/add_post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final AddPostUseCase addPostUseCase;

  PostBloc({required this.addPostUseCase}) : super(PostInitial()) {

    on<SubmitPostEvent>((event, emit) async {
      emit(PostLoading()); // Loading state dekhachhi

      // UseCase call korchi jeta Either<Failure, bool> return korbe
      final result = await addPostUseCase.call(event.title, event.userId);

      // 🎯 fold() method use kore Left (Failure) abong Right (Success) alada korbo
      result.fold(
            (failure) {
          // Left side: Error/Failure ashle ekhane ashbe
          emit(PostFailure(failure.message)); // Apnar state-e message thakle pass korben
        },
            (isSuccess) {
          // Right side: Ekhane 'isSuccess' holo prokrito 'bool' data-ti
          if (isSuccess) {
            emit(PostSuccess());
          } else {
            emit(PostFailure("Failed to Add Post."));
          }
        },
      );
    });
  }
}