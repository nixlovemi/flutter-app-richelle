// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegistrationResponseBody _$RegistrationResponseBodyFromJson(
  Map<String, dynamic> json,
) => RegistrationResponseBody(
  message: json['message'] as String,
  user: User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RegistrationResponseBodyToJson(
  RegistrationResponseBody instance,
) => <String, dynamic>{'message': instance.message, 'user': instance.user};

RegistrationResponse _$RegistrationResponseFromJson(
  Map<String, dynamic> json,
) => RegistrationResponse(
  success: json['success'] as bool?,
  message: json['message'] as String,
  body: json['body'] == null
      ? null
      : RegistrationResponseBody.fromJson(json['body'] as Map<String, dynamic>),
  errors: json['errors'],
  timestamp: json['timestamp'] as String?,
  statusCode: (json['status_code'] as num?)?.toInt(),
);

Map<String, dynamic> _$RegistrationResponseToJson(
  RegistrationResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'body': instance.body,
  'errors': instance.errors,
  'timestamp': instance.timestamp,
  'status_code': instance.statusCode,
};
