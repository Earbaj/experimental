import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final int id;
  final String title;
  final String body;
  final List<String> tags;
  final int likes;
  final int dislikes;
  final int views;
  final int userId;

  const PostEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.likes,
    required this.dislikes,
    required this.views,
    required this.userId,
  });

  @override
  List<Object?> get props => [id, title, body, tags, likes, dislikes, views, userId];
}