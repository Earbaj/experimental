abstract class PostState {}

class PostInitial extends PostState {}
class PostLoading extends PostState {}
class PostSuccess extends PostState {}
class PostFailure extends PostState {
  final String message;
  PostFailure(this.message);
}