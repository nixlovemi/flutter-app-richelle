import 'api_error.dart';

/// Generic API response wrapper that handles both success and error states
class ApiResponse<T> {
  final T? data;
  final ApiError? error;
  final bool isSuccess;
  final int statusCode;

  const ApiResponse._({
    this.data,
    this.error,
    required this.isSuccess,
    required this.statusCode,
  });

  /// Create a successful response
  factory ApiResponse.success(T data, int statusCode) {
    return ApiResponse._(
      data: data,
      isSuccess: true,
      statusCode: statusCode,
    );
  }

  /// Create an error response
  factory ApiResponse.error(ApiError error, int statusCode) {
    return ApiResponse._(
      error: error,
      isSuccess: false,
      statusCode: statusCode,
    );
  }

  /// Create a network error response
  factory ApiResponse.networkError(String message) {
    return ApiResponse._(
      error: ApiError(message: message, code: 0),
      isSuccess: false,
      statusCode: 0,
    );
  }

  @override
  String toString() {
    if (isSuccess) {
      return 'ApiResponse.success(data: $data, statusCode: $statusCode)';
    } else {
      return 'ApiResponse.error(error: $error, statusCode: $statusCode)';
    }
  }
}