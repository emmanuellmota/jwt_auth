import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jwt_token.g.dart';

@JsonSerializable()
class JwtToken extends Equatable {
  @JsonKey(name: 'username')
  final String username;

  @JsonKey(name: 'accessToken')
  final String accessToken;

  @JsonKey(name: 'expiresIn')
  final int expiresAt;

  @JsonKey(name: 'refreshToken')
  final String refreshToken;

  @JsonKey(name: 'refreshTokenExpiresIn')
  final int refreshTokenExpiresAt;

  const JwtToken({
    required this.username,
    required this.accessToken,
    required this.expiresAt,
    required this.refreshToken,
    required this.refreshTokenExpiresAt,
  });

  factory JwtToken.fromJson(Map<String, dynamic> json) =>
      _$JwtTokenFromJson(json);

  Map<String, dynamic> toJson() => _$JwtTokenToJson(this);

  static String serialize(JwtToken model) => json.encode(model.toJson());

  static JwtToken deserialize(String json) =>
      JwtToken.fromJson(jsonDecode(json));

  @override
  List<Object> get props => [username, accessToken, refreshToken];

  isAccessTokenExpired() {
    var now = DateTime.now().toUtc().millisecondsSinceEpoch;
    return now > expiresAt;
  }

  isRefreshTokenExpired() {
    var now = DateTime.now().toUtc().millisecondsSinceEpoch;
    return now > refreshTokenExpiresAt;
  }
}
