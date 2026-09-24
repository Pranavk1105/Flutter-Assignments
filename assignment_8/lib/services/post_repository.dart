import 'package:assignment_8/models/post_result.dart';
import 'package:assignment_8/services/api_service.dart';
import 'package:assignment_8/services/cache_service.dart';

/// Repository that coordinates fetching posts from the network or falling back to
/// the local [SharedPreferences] cache.
class PostRepository {
  final ApiService _apiService;
  final CacheService _cacheService;

  /// When true, network calls are skipped to demonstrate offline behavior
  /// and verify caching capabilities without turning off system internet.
  bool simulateOffline = false;

  PostRepository({
    ApiService? apiService,
    CacheService? cacheService,
  })  : _apiService = apiService ?? ApiService(),
        _cacheService = cacheService ?? CacheService();

  /// Fetches posts.
  ///
  /// Workflow:
  /// 1. If [simulateOffline] is active, attempts to load from SharedPreferences.
  /// 2. If online and not forced offline, attempts to load from JSONPlaceholder REST API.
  ///    - On success: updates cache and returns live data ([isFromCache] = false).
  ///    - On error: checks cache. If cache exists, returns cached data with a notice.
  ///    - If no cache exists: throws an informative Exception.
  Future<PostResult> fetchPosts({bool forceRefresh = false}) async {
    // Check if offline simulation is toggled on
    if (simulateOffline) {
      final cached = await _cacheService.getCachedPosts();
      final cacheTime = await _cacheService.getCacheTimestamp();

      if (cached != null && cached.isNotEmpty) {
        return PostResult(
          posts: cached,
          isFromCache: true,
          timestamp: cacheTime ?? DateTime.now(),
          notice: 'Offline mode active: Data loaded from SharedPreferences cache.',
        );
      } else {
        throw const ApiException(
          'Offline mode simulated, but no cached posts were found in SharedPreferences. '
          'Please disable offline mode to fetch and cache data first.',
        );
      }
    }

    // Normal flow: Attempt live network fetch
    try {
      final posts = await _apiService.fetchPosts();
      final now = DateTime.now();

      // Persist to SharedPreferences cache
      await _cacheService.savePosts(posts, now);

      return PostResult(
        posts: posts,
        isFromCache: false,
        timestamp: now,
      );
    } catch (networkError) {
      // Network failed: fallback to SharedPreferences cache
      final cached = await _cacheService.getCachedPosts();
      final cacheTime = await _cacheService.getCacheTimestamp();

      if (cached != null && cached.isNotEmpty) {
        return PostResult(
          posts: cached,
          isFromCache: true,
          timestamp: cacheTime ?? DateTime.now(),
          notice:
              'Network unavailable (${_cleanErrorMessage(networkError)}). '
              'Serving cached data from SharedPreferences.',
        );
      }

      // No cache and network failed: throw user-friendly error
      throw ApiException(
        'Unable to load posts from API and no local cache is available. '
        'Error: ${_cleanErrorMessage(networkError)}',
      );
    }
  }

  /// Clears the cached posts from local storage.
  Future<void> clearCache() => _cacheService.clearCache();

  /// Checks if any cache exists.
  Future<bool> hasCachedData() => _cacheService.hasCachedPosts();

  /// Returns the timestamp of the last cache write.
  Future<DateTime?> getLastCacheTime() => _cacheService.getCacheTimestamp();

  /// Formats raw error messages for clean presentation.
  String _cleanErrorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }
    return error.toString().replaceAll('Exception: ', '');
  }
}
