/// Represents a blog post item fetched from the JSONPlaceholder REST API.
class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  /// Deserializes a JSON map into a [Post] instance.
  /// Uses Dart 3 pattern matching with safe fallbacks.
  factory Post.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': final int id,
        'userId': final int userId,
        'title': final String title,
        'body': final String body,
      } =>
        Post(id: id, userId: userId, title: title, body: body),
      _ => Post(
          id: (json['id'] as num?)?.toInt() ?? 0,
          userId: (json['userId'] as num?)?.toInt() ?? 0,
          title: json['title'] as String? ?? '',
          body: json['body'] as String? ?? '',
        ),
    };
  }

  /// Serializes this [Post] instance into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };
  }

  /// Returns a clean capitalized title for display.
  String get capitalizedTitle {
    if (title.isEmpty) return 'Untitled Post';
    return title[0].toUpperCase() + title.substring(1);
  }

  /// Formatted identifier string (e.g. #042).
  String get formattedId => '#${id.toString().padLeft(3, '0')}';

  /// A short snippet preview of the body.
  String get snippet {
    final clean = body.replaceAll('\n', ' ').trim();
    if (clean.length <= 90) return clean;
    return '${clean.substring(0, 87)}...';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Post &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          title == other.title &&
          body == other.body;

  @override
  int get hashCode => Object.hash(id, userId, title, body);

  @override
  String toString() => 'Post(id: $id, userId: $userId, title: "$title")';
}
