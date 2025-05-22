import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jwt_auth/models/jwt_auth_config.dart';
import 'package:jwt_auth/models/jwt_token.dart';

class JwtAuthApiClient extends Interceptor {
  final dio = Dio(
    BaseOptions(
      contentType: 'application/json; charset=UTF-8',
    ),
  );

  final JwtAuthConfig config;

  JwtAuthApiClient({
    required this.config,
  });

  token(String username, String password) async {
    var response = await dio.post(
      config.tokenUrl,
      data: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      var jwtToken = JwtToken.fromJson(response.data as Map<String, dynamic>);
      // _setToken(jwtToken);
      return jwtToken;
    } else {
      // _cleanToken();
      // var error = _handleError(response);
      throw Exception(response.data);
    }
  }

  Future<JwtToken> refreshToken(String username, String refreshToken) async {
    var response = await dio.post(
      config.refreshUrl,
      data: {
        'username': username,
        'refreshToken': refreshToken,
      },
    );

    if (response.statusCode == 200) {
      var jwtToken = JwtToken.fromJson(response.data as Map<String, dynamic>);
      // _setToken(_jwtToken!);
      return jwtToken;
    } else {
      // var error = _handleError(response);
      throw Exception(response.data);
    }
  }
}
