import 'package:equatable/equatable.dart';
import 'package:jwt_auth/models/jwt_authentication_status.dart';
import 'package:jwt_auth/models/jwt_response_error.dart';
import 'package:jwt_auth/models/jwt_token.dart';

class JwtAuthenticationState extends Equatable {
  final String? username;
  final String? accessToken;
  final JwtAuthenticationStatus status;
  final JwtResponseError? error;

  const JwtAuthenticationState._({
    this.username,
    this.accessToken,
    this.status = JwtAuthenticationStatus.unknown,
    this.error,
  });

  const JwtAuthenticationState.unknown() : this._();

  JwtAuthenticationState.authenticated(JwtToken jwtToken)
      : this._(
            username: jwtToken.username,
            accessToken: jwtToken.accessToken,
            status: JwtAuthenticationStatus.authenticated);

  const JwtAuthenticationState.unauthenticated()
      : this._(status: JwtAuthenticationStatus.unauthenticated);

  const JwtAuthenticationState.error(JwtResponseError error)
      : this._(status: JwtAuthenticationStatus.error, error: error);

  @override
  List<Object?> get props => [accessToken, username, status];
}
