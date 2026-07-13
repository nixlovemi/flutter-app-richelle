import 'package:json_annotation/json_annotation.dart';

part 'api_wrapper.g.dart';

/// Wrapper for all API responses from the Laravel backend
@JsonSerializable(genericArgumentFactories: true)
class ApiWrapper<T> {
  final bool success;
  final String message;
  final T? body;
  final Map<String, List<String>>? errors;
  final DateTime timestamp;
  @JsonKey(name: 'status_code')
  final int statusCode;

  const ApiWrapper({
    required this.success,
    required this.message,
    this.body,
    this.errors,
    required this.timestamp,
    required this.statusCode,
  });

  factory ApiWrapper.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiWrapperFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ApiWrapperToJson(this, toJsonT);

  @override
  String toString() => 'ApiWrapper(success: $success, message: $message, statusCode: $statusCode)';

  /// Check if the API response is successful
  bool get isSuccess => success && statusCode >= 200 && statusCode < 300;

  /// Get the first error message for a specific field
  String? getFieldError(String field) {
    return errors?[field]?.isNotEmpty == true ? errors![field]!.first : null;
  }

  /// Get all error messages as a single string
  String get allErrorMessages {
    if (errors?.isEmpty ?? true) return message;
    
    final List<String> allErrors = [message];
    for (var fieldErrors in errors!.values) {
      allErrors.addAll(fieldErrors);
    }
    return allErrors.join('\n');
  }
}