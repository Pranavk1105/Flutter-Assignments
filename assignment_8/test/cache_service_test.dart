import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assignment_8/models/post.dart';
import 'package:assignment_8/services/cache_service.dart';

void main() {
  group('CacheService Tests', () {
    late CacheService cacheService;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      cacheService = CacheService();
    });

    test('hasCachedPosts returns false when cache is empty', () async {
      final exists = await cacheService.hasCachedPosts();
      expect(exists, isFalse);

      final posts = await cacheService.getCachedPosts();
      expect(posts, isNull);
    });

    test('savePosts persists posts and timestamp into SharedPreferences', () async {
      const samplePosts = [
        Post(id: 1, userId: 1, title: 'Test 1', body: 'Body 1'),
        Post(id: 2, userId: 1, title: 'Test 2', body: 'Body 2'),
      ];
      final timestamp = DateTime(2026, 9, 19, 22, 0, 0);

      await cacheService.savePosts(samplePosts, timestamp);

      final hasCache = await cacheService.hasCachedPosts();
      expect(hasCache, isTrue);

      final cached = await cacheService.getCachedPosts();
      expect(cached, isNotNull);
      expect(cached!.length, 2);
      expect(cached[0].title, 'Test 1');
      expect(cached[1].id, 2);

      final savedTime = await cacheService.getCacheTimestamp();
      expect(savedTime, equals(timestamp));
    });

    test('clearCache removes data and timestamp from SharedPreferences', () async {
      const samplePosts = [
        Post(id: 1, userId: 1, title: 'Sample', body: 'Content'),
      ];

      await cacheService.savePosts(samplePosts);
      expect(await cacheService.hasCachedPosts(), isTrue);

      await cacheService.clearCache();
      expect(await cacheService.hasCachedPosts(), isFalse);
      expect(await cacheService.getCachedPosts(), isNull);
      expect(await cacheService.getCacheTimestamp(), isNull);
    });

    test('getCachedPosts gracefully returns null when corrupted data is encountered', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(CacheService.keyCachedPosts, 'invalid_json{]');

      final cached = await cacheService.getCachedPosts();
      expect(cached, isNull);
    });
  });
}
