import 'package:json_annotation/json_annotation.dart';

part 'api_error.g.dart';

@JsonSerializable()
class ApiError {
  final String message;
  final Map<String, List<String>>? errors;
  final int? code;

  const ApiError({
    required this.message,
    this.errors,
    this.code,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) => _$ApiErrorFromJson(json);
  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);

  @override
  String toString() => 'ApiError(message: $message, code: $code)';

  /// Get the first error message for a specific field
  String? getFieldError(String field) {
    return errors?[field]?.isNotEmpty == true ? errors![field]!.first : null;
  }

  /// Get all error messages as a single string
  String get allMessages {
    if (errors?.isEmpty ?? true) return message;
    
    final List<String> allErrors = [message];
    for (var fieldErrors in errors!.values) {
      allErrors.addAll(fieldErrors);
    }
    return allErrors.join('\n');
  }
}