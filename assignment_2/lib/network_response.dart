/// Sealed class hierarchy representing the outcome of an async network call
sealed class NetworkResponse<T> {}

/// Indicates a successful network response with typed payload
class ResponseSuccess<T> extends NetworkResponse<T> {
  final T payload;
  final int httpStatus;

  ResponseSuccess(this.payload, {this.httpStatus = 200});
}

/// Indicates a failed network response with a descriptive error
class ResponseFailure<T> extends NetworkResponse<T> {
  final String reason;
  final int? httpStatus;

  ResponseFailure(this.reason, {this.httpStatus});
}

/// Indicates an empty network response (e.g., resource not found)
class ResponseNoContent<T> extends NetworkResponse<T> {
  final String description;

  ResponseNoContent({this.description = 'The requested resource returned no data.'});
}
