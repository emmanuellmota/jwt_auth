// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jwt_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JwtToken _$JwtTokenFromJson(Map<String, dynamic> json) => JwtToken(
      username: json['username'] as String,
      accessToken: json['accessToken'] as String,
      expiresAt: (json['expiresIn'] as num).toInt(),
      refreshToken: json['refreshToken'] as String,
      refreshTokenExpiresAt: (json['refreshTokenExpiresIn'] as num).toInt(),
    );

Map<String, dynamic> _$JwtTokenToJson(JwtToken instance) => <String, dynamic>{
      'username': instance.username,
      'accessToken': instance.accessToken,
      'expiresIn': instance.expiresAt,
      'refreshToken': instance.refreshToken,
      'refreshTokenExpiresIn': instance.refreshTokenExpiresAt,
    };
