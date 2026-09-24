import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:assignment_8/models/post.dart';

/// Exception thrown when an error occurs during an API operation.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Uri? uri;

  const ApiException(this.message, {this.statusCode, this.uri});

  @override
  String toString() => message;
}

/// Service responsible for communicating with the JSONPlaceholder REST API.
class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String postsEndpoint = '$baseUrl/posts';

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches the list of posts from the REST API.
  ///
  /// Throws [ApiException] on network disconnection, timeout,
  /// or non-200 HTTP status codes.
  Future<List<Post>> fetchPosts({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final uri = Uri.parse(postsEndpoint);

    try {
      final response = await _client.get(
        uri,
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is! List) {
          throw const ApiException('Expected a JSON list of posts.');
        }

        return decoded
            .map<Post>((item) => Post.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException(
          'Failed to load posts from API. Server responded with HTTP ${response.statusCode}.',
          statusCode: response.statusCode,
          uri: uri,
        );
      }
    } on TimeoutException {
      throw ApiException(
        'Request timed out. Please check your internet connection.',
        uri: uri,
      );
    } on http.ClientException catch (e) {
      throw ApiException(
        'Network error: ${e.message}',
        uri: uri,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        'Unexpected connection error: $e',
        uri: uri,
      );
    }
  }

  /// Closes the internal HTTP client when no longer needed.
  void dispose() {
    _client.close();
  }
}
