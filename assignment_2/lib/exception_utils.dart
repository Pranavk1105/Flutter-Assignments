/// Custom exception class for handling network-related errors
class NetworkException implements Exception {
  final String details;
  final int? httpCode;

  NetworkException(this.details, {this.httpCode});

  @override
  String toString() => 'NetworkException [Code ${httpCode ?? "Unknown"}]: $details';
}

/// Utility with `Never` return type that always throws a NetworkException
/// Demonstrates the `Never` return type for guaranteed non-returning functions
Never raiseNetworkError(String details, {int? httpCode}) {
  throw NetworkException(details, httpCode: httpCode);
}

/// Ensures the provided response body is not null before further processing
void ensureResponseNotNull(Object? body, {String label = 'Response Body'}) {
  if (body == null) {
    raiseNetworkError('$label is null or missing — cannot proceed', httpCode: 400);
  }
}
