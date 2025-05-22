import 'package:jwt_auth/models/jwt_auth_log_level.dart';

class JwtAuthConfig {
  final String tokenUrl;
  final String refreshUrl;
  final JwtAuthLogLevel logLevel;

  JwtAuthConfig({
    required this.tokenUrl,
    required this.refreshUrl,
    required this.logLevel,
  });
}
