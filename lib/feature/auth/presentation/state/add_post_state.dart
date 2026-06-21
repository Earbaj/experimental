abstract class AddPostState {}

class PostInitial extends AddPostState {}
class PostLoading extends AddPostState {}
class PostSuccess extends AddPostState {}
class PostFailure extends AddPostState {
  final String message;
  PostFailure(this.message);
}