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
    final reactions = json['reactions'];
    int parsedLikes = 0;
    int parsedDislikes = 0;

    if (reactions is Map) {
      parsedLikes = reactions['likes'] as int? ?? 0;
      parsedDislikes = reactions['dislikes'] as int? ?? 0;
    }

    return PostModel(
      id: json['id'] as int? ?? 0,
      // Using .toString() forces any structural data type into a safe String representation
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      tags: (json['tags'] as List? ?? [])
          .map((tag) => tag.toString())
          .toList(),
      likes: parsedLikes,
      dislikes: parsedDislikes,
      views: json['views'] as int? ?? 0,
      userId: json['userId'] as int? ?? 0,
    );
  }
}