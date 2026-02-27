import 'package:json_annotation/json_annotation.dart';

part 'registration_request.g.dart';

/// Request model for user registration
@JsonSerializable()
class RegistrationRequest {
  @JsonKey(name: 'first_name')
  final String firstName;
  
  @JsonKey(name: 'last_name')
  final String lastName;
  
  final String email;
  final String password;
  
  @JsonKey(name: 'password_confirmation')
  final String passwordConfirmation;

  const RegistrationRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  /// Create from JSON
  factory RegistrationRequest.fromJson(Map<String, dynamic> json) =>
      _$RegistrationRequestFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$RegistrationRequestToJson(this);

  @override
  String toString() {
    return 'RegistrationRequest(firstName: $firstName, lastName: $lastName, email: $email)';
  }
}