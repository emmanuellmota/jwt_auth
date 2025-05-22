import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'jwt_response_error.g.dart';

@JsonSerializable()
class JwtResponseError implements Exception {
  @JsonKey(name: 'isSuccess')
  final bool isSuccess;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'stacktrace')
  final String? stacktrace;

  @JsonKey(includeFromJson: false, includeToJson: false)
  int? statusCode;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? statusMessage;

  get isUnhautorized => statusCode == 401;

  JwtResponseError({
    required this.isSuccess,
    required this.message,
    required this.stacktrace,
  });

  factory JwtResponseError.fromJson(Map<String, dynamic> json) =>
      _$JwtResponseErrorFromJson(json);

  Map<String, dynamic> toJson() => _$JwtResponseErrorToJson(this);

  static String serialize(JwtResponseError model) =>
      json.encode(model.toJson());

  static JwtResponseError deserialize(String json) =>
      JwtResponseError.fromJson(jsonDecode(json));

  @override
  String toString() {
    return "CustomException: $message";
  }

  // @override
  // List<Object?> get props =>
  //     [message, isSuccess, stacktrace, statusCode, statusMessage];
}
