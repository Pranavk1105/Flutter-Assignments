import 'dart:async';
import 'network_response.dart';
import 'exception_utils.dart';
import 'user_account.dart';

class SimulatedApiClient {
  // Late final field with lazy initialization for base URL
  late final String baseUrl = _resolveBaseUrl();

  final int latencyMs;

  SimulatedApiClient({this.latencyMs = 500});

  String _resolveBaseUrl() {
    return 'https://api.devhub.internal/v2';
  }

  /// Internal mock data store simulating a remote user database
  final Map<int, Map<String, dynamic>?> _userRecords = {
    // User 101: Fully populated profile record
    101: {
      'id': 101,
      'name': 'Pranav Kale',
      'email': 'pranav@example.com',
      'bio': 'Full-Stack Mobile Developer specializing in Dart & Flutter',
      'phoneNumber': '+91 99887 76655',
      'rating': 4.8,
      'skills': ['Dart', 'Flutter', 'Firebase', 'REST APIs'],
      'preferences': {
        'theme': 'Midnight Dark',
        'notificationsEnabled': true,
      },
    },

    // User 102: Sparse profile with null / missing optional fields
    102: {
      'id': 102,
      'name': 'Ananya Gupta',
      'email': 'ananya.gupta@example.com',
      'bio': null,              // Nullable field
      'phoneNumber': null,      // Nullable field
      'rating': null,           // Nullable field
      'skills': null,           // Nullable list
      'preferences': null,      // Nullable map
    },

    // User 404: Explicit null entry to simulate a missing resource
    404: null,
  };

  /// Low-level fetch simulating an HTTP GET with artificial latency
  Future<Map<String, dynamic>?> getRawUserRecord(int userId) async {
    // Simulating asynchronous network delay
    await Future.delayed(Duration(milliseconds: latencyMs));

    // Simulate 500 Internal Server Error scenario
    if (userId == 500) {
      raiseNetworkError(
        'Internal Server Error: Primary database node is unreachable.',
        httpCode: 500,
      );
    }

    // Simulate 403 Forbidden Error scenario
    if (userId == 403) {
      raiseNetworkError(
        'Access Denied: The provided authorization token has expired.',
        httpCode: 403,
      );
    }

    // Check if user exists in the mock data store
    if (!_userRecords.containsKey(userId)) {
      return null;
    }

    return _userRecords[userId];
  }

  /// High-level async method returning a sealed NetworkResponse<UserAccount>
  Future<NetworkResponse<UserAccount>> getUserAccount(int userId) async {
    try {
      print('  → Dispatching async GET to: $baseUrl/users/$userId');

      Map<String, dynamic>? rawData = await getRawUserRecord(userId);

      // Null check to handle 404 / Missing resource case
      if (rawData == null) {
        return ResponseNoContent(
          description: 'No user record found for ID #$userId (HTTP 404 — Not Found).',
        );
      }

      // Ensure payload integrity before parsing
      ensureResponseNotNull(rawData, label: 'User Account Payload');

      // Parse the raw data using the null-safe factory constructor
      UserAccount account = UserAccount.fromJson(rawData);
      return ResponseSuccess(account, httpStatus: 200);

    } on NetworkException catch (e) {
      // Handle known network-layer exceptions
      return ResponseFailure(e.details, httpStatus: e.httpCode);
    } catch (e) {
      // Catch-all for any unforeseen errors
      return ResponseFailure('Unexpected error encountered: $e', httpStatus: 520);
    }
  }

  /// Fetches a batch list of gadget items for generic collection transformation demo
  Future<NetworkResponse<List<Map<String, dynamic>>>> getGadgetInventory() async {
    try {
      await Future.delayed(Duration(milliseconds: latencyMs));

      List<Map<String, dynamic>> gadgets = [
        {'id': 'G-101', 'title': 'Bluetooth Earbuds', 'price': 49.99, 'stock': 22},
        {'id': 'G-102', 'title': 'Portable SSD 1TB', 'price': 119.00, 'stock': 9},
        {'id': 'G-103', 'title': 'RGB Mechanical Keyboard', 'price': 94.50, 'stock': 17},
        {'id': 'G-104', 'title': 'Thunderbolt Dock Station', 'price': 189.75, 'stock': 0},
      ];

      return ResponseSuccess(gadgets);
    } catch (e) {
      return ResponseFailure('Gadget inventory fetch failed: $e');
    }
  }
}
