import 'package:assignment_8/models/post.dart';

/// Wraps the result of a fetch operation, containing post records and cache metadata.
class PostResult {
  /// The list of retrieved posts.
  final List<Post> posts;

  /// True if the returned posts originated from local SharedPreferences cache.
  final bool isFromCache;

  /// The timestamp when the data was fetched or cached.
  final DateTime timestamp;

  /// Optional contextual notice (e.g., offline warning or fallback message).
  final String? notice;

  const PostResult({
    required this.posts,
    required this.isFromCache,
    required this.timestamp,
    this.notice,
  });

  /// Formats the timestamp into a human-readable display string.
  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final second = timestamp.second.toString().padLeft(2, '0');
    final day = timestamp.day.toString().padLeft(2, '0');
    final month = _monthName(timestamp.month);
    return '$day $month ${timestamp.year} at $hour:$minute:$second';
  }

  static String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }
}
