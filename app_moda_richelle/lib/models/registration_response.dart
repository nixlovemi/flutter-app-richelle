import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'registration_response.g.dart';

/// Response body containing the actual registration data
@JsonSerializable()
class RegistrationResponseBody {
  final String message;
  final User user;

  const RegistrationResponseBody({
    required this.message,
    required this.user,
  });

  factory RegistrationResponseBody.fromJson(Map<String, dynamic> json) =>
      _$RegistrationResponseBodyFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationResponseBodyToJson(this);
}

/// Response model for user registration (matches API structure)
@JsonSerializable()
class RegistrationResponse {
  final bool? success;  // Made nullable to handle potential null values
  final String message;
  final RegistrationResponseBody? body;  // Made nullable
  final dynamic errors;
  final String? timestamp;  // Made nullable
  
  @JsonKey(name: 'status_code')
  final int? statusCode;  // Made nullable

  const RegistrationResponse({
    this.success,  // Optional to handle null
    required this.message,
    this.body,  // Optional
    this.errors,
    this.timestamp,  // Optional
    this.statusCode,  // Optional
  });

  /// Create from JSON
  factory RegistrationResponse.fromJson(Map<String, dynamic> json) =>
      _$RegistrationResponseFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$RegistrationResponseToJson(this);

  @override
  String toString() {
    return 'RegistrationResponse(success: $success, message: $message)';
  }
}