// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginBody _$LoginBodyFromJson(Map<String, dynamic> json) => LoginBody(
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  token: json['token'] as String,
  tokenType: json['token_type'] as String,
);

Map<String, dynamic> _$LoginBodyToJson(LoginBody instance) => <String, dynamic>{
  'user': instance.user,
  'token': instance.token,
  'token_type': instance.tokenType,
};
