import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assignment_8/models/post.dart';

/// Manages caching of posts data locally using [SharedPreferences].
class CacheService {
  static const String keyCachedPosts = 'cached_posts_data';
  static const String keyCachedTime = 'cached_posts_time';

  /// Saves the given list of [Post]s into [SharedPreferences] as a serialized JSON string.
  /// Also stores the cache write timestamp.
  Future<void> savePosts(List<Post> posts, [DateTime? timestamp]) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStringList = jsonEncode(posts.map((p) => p.toJson()).toList());
    final saveTime = (timestamp ?? DateTime.now()).toIso8601String();

    await prefs.setString(keyCachedPosts, jsonStringList);
    await prefs.setString(keyCachedTime, saveTime);
  }

  /// Retrieves the cached posts from [SharedPreferences], or null if no cache is present.
  Future<List<Post>?> getCachedPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString(keyCachedPosts);

    if (rawJson == null || rawJson.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is! List) return null;

      return decoded
          .map<Post>((item) => Post.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // In case of corrupt or invalid cached data, return null
      return null;
    }
  }

  /// Retrieves the timestamp when the data was last saved to [SharedPreferences].
  Future<DateTime?> getCacheTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    final timeStr = prefs.getString(keyCachedTime);
    if (timeStr == null || timeStr.isEmpty) return null;

    try {
      return DateTime.parse(timeStr);
    } catch (_) {
      return null;
    }
  }

  /// Checks if cached posts exist in [SharedPreferences].
  Future<bool> hasCachedPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString(keyCachedPosts);
    return rawJson != null && rawJson.isNotEmpty;
  }

  /// Clears the cached posts and timestamp from [SharedPreferences].
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyCachedPosts);
    await prefs.remove(keyCachedTime);
  }
}
