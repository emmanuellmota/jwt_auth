import 'dart:async';

import 'package:dio/dio.dart';
import 'package:jwt_auth/jwt_auth_api_client.dart';
import 'package:jwt_auth/jwt_auth_storage.dart';
import 'package:jwt_auth/models/jwt_auth_config.dart';
import 'package:jwt_auth/models/jwt_authentication_status.dart';
import 'package:jwt_auth/models/jwt_response_error.dart';
import 'package:jwt_auth/models/jwt_token.dart';

class JwtAuthenticationRepository {
  final _statusStream = StreamController<JwtAuthenticationStatus>();
  final _jwtTokenStream = StreamController<JwtToken?>();

  final JwtAuthConfig _config;
  final JwtAuthApiClient _jwtAuthApiClient;
  final JwtAuthStorage _jwtAuthStorage = JwtAuthStorage();

  late JwtToken? _jwtToken;
  late Uri tokenUri;
  late Uri refreshUri;

  JwtToken? get jwtToken => _jwtToken;

  JwtAuthenticationRepository({
    required JwtAuthConfig config,
    JwtAuthApiClient? jwtAuthApiClient,
  })  : _config = config,
        _jwtAuthApiClient =
            jwtAuthApiClient ?? JwtAuthApiClient(config: config);

  Stream<JwtAuthenticationStatus> get statusStream async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield JwtAuthenticationStatus.unauthenticated;
    yield* _statusStream.stream;
  }

  Stream<JwtToken?> get jwtTokenStream async* {
    yield* _jwtTokenStream.stream;
  }

  initialize() async {
    _checkConfiguration();

    var jwtToken = await _jwtAuthStorage.getJwtToken();

    if (jwtToken == null) {
      _cleanToken();
      return;
    }

    if (jwtToken.isAccessTokenExpired()) {
      if (jwtToken.isRefreshTokenExpired()) {
        _cleanToken();
        return;
      }

      try {
        jwtToken = await _jwtAuthApiClient.refreshToken(
            jwtToken.username, jwtToken.refreshToken);
      } catch (e) {
        _cleanToken();
        return;
      }
    }

    _setToken(jwtToken);
  }

  Future<JwtToken> login(String username, String password) async {
    try {
      var jwtToken = await _jwtAuthApiClient.token(username, password);
      _setToken(jwtToken);
      return jwtToken;
    } on DioException catch (e) {
      var error = _handleError(e);
      throw error;
    } catch (e) {
      rethrow;
    }
  }

  Future<JwtToken> refreshToken() async {
    try {
      var jwtToken = await _jwtAuthApiClient.refreshToken(
          _jwtToken!.username, _jwtToken!.refreshToken);
      _setToken(jwtToken);
      return jwtToken;
    } on DioException catch (e) {
      var error = _handleError(e);
      throw error;
    } catch (e) {
      rethrow;
    }
  }

  logout() {
    _cleanToken();
  }

  dispose() {
    _statusStream.close();
    _jwtTokenStream.close();
    _cleanToken();
  }

  _checkConfiguration() {
    if (_config.tokenUrl == '') {
      throw Exception('Token URL is required');
    }

    tokenUri = Uri.parse(_config.tokenUrl);

    if (_config.refreshUrl == '') {
      throw Exception('Refresh URL is required');
    }

    refreshUri = Uri.parse(_config.refreshUrl);
  }

  _setToken(JwtToken? jwtToken) async {
    _jwtToken = jwtToken;
    _jwtTokenStream.add(_jwtToken);
    if (jwtToken != null) {
      await _jwtAuthStorage.saveJwtToken(jwtToken);
    }
  }

  _cleanToken() async {
    _jwtToken = null;
    _jwtTokenStream.add(null);
    await _jwtAuthStorage.deleteJwtToken();
  }

  _handleError(DioException e) {
    JwtResponseError responseError;

    if (e.response != null && e.response!.data != null) {
      responseError =
          JwtResponseError.fromJson(e.response!.data as Map<String, dynamic>);
    } else {
      responseError = JwtResponseError(
        isSuccess: false,
        message: 'An error occurred: ${e.message}',
        stacktrace: null,
      );
    }

    responseError.statusCode = e.response!.statusCode;
    responseError.statusMessage = e.response!.statusMessage;

    return responseError;
  }
}
