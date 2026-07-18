import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../domain/usecase/add_post_usecase.dart';
import '../state/add_post_state.dart';

class AddPostViewModel extends StateNotifier<AddPostState> {
  final AddPostUseCase addPostUseCase;

  AddPostViewModel({required this.addPostUseCase}) : super(PostInitial());

  // BLoC-er event logic ekhon ViewModel-er ekti normal method
  Future<void> submitPost({required String title, required int userId}) async {
    state = PostLoading();

    final result = await addPostUseCase.call(title, userId);

    result.fold(
          (failure) => state = PostFailure(failure.message),
          (isSuccess) {
        if (isSuccess) {
          state = PostSuccess();
        } else {
          state = PostFailure("Failed to Add Post.");
        }
      },
    );
  }
}
