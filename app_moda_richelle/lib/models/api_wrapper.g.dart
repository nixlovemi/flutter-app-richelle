// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_wrapper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiWrapper<T> _$ApiWrapperFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => ApiWrapper<T>(
  success: json['success'] as bool,
  message: json['message'] as String,
  body: _$nullableGenericFromJson(json['body'], fromJsonT),
  errors: (json['errors'] as Map<String, dynamic>?)?.map(
    (k, e) =>
        MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
  ),
  timestamp: DateTime.parse(json['timestamp'] as String),
  statusCode: (json['status_code'] as num).toInt(),
);

Map<String, dynamic> _$ApiWrapperToJson<T>(
  ApiWrapper<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'body': _$nullableGenericToJson(instance.body, toJsonT),
  'errors': instance.errors,
  'timestamp': instance.timestamp.toIso8601String(),
  'status_code': instance.statusCode,
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);
