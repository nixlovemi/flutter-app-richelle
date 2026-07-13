import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'login_body.g.dart';

@JsonSerializable()
class LoginBody {
  final User user;
  final String token;
  @JsonKey(name: 'token_type')
  final String tokenType;

  const LoginBody({
    required this.user,
    required this.token,
    required this.tokenType,
  });

  factory LoginBody.fromJson(Map<String, dynamic> json) => 
      _$LoginBodyFromJson(json);
  
  Map<String, dynamic> toJson() => _$LoginBodyToJson(this);

  @override
  String toString() => 'LoginBody(user: ${user.fullName}, tokenType: $tokenType)';
}