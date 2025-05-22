// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jwt_response_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JwtResponseError _$JwtResponseErrorFromJson(Map<String, dynamic> json) =>
    JwtResponseError(
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
      stacktrace: json['stacktrace'] as String?,
    );

Map<String, dynamic> _$JwtResponseErrorToJson(JwtResponseError instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'stacktrace': instance.stacktrace,
    };
