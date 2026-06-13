class PostModel {
  final int id;
  final String title;
  final String body;
  final List<String> tags;
  final int likes;
  final int dislikes;
  final int views;
  final int userId;

  PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.likes,
    required this.dislikes,
    required this.views,
    required this.userId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final reactions = json['reactions'] as Map<String, dynamic>? ?? {};
    return PostModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      likes: reactions['likes'] ?? 0,
      dislikes: reactions['dislikes'] ?? 0,
      views: json['views'] ?? 0,
      userId: json['userId'] ?? 0,
    );
  }
}