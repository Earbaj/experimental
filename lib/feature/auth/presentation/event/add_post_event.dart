abstract class PostEvent {}

class SubmitPostEvent extends PostEvent {
  final String title;
  final int userId;

  SubmitPostEvent({required this.title, required this.userId});
}