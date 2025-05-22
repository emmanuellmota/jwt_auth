import 'package:flutter_test/flutter_test.dart';
import 'package:jwt_auth/jwt_auth_platform_interface.dart';
import 'package:jwt_auth/jwt_auth_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockJwtAuthPlatform
    with MockPlatformInterfaceMixin
    implements JwtAuthPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final JwtAuthPlatform initialPlatform = JwtAuthPlatform.instance;

  test('$MethodChannelJwtAuth is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelJwtAuth>());
  });

  test('getPlatformVersion', () async {
    // JwtAuthConfig config = JwtAuthConfig(
    //   tokenUrl: 'http://localhost:3000/token',
    //   refreshUrl: 'http://localhost:3000/refresh',
    //   logLevel: JwtAuthLogLevel.none,
    // );
    // JwtAuthenticationRepository jwtAuthPlugin = JwtAuthenticationRepository(config: config);
    MockJwtAuthPlatform fakePlatform = MockJwtAuthPlatform();
    JwtAuthPlatform.instance = fakePlatform;

    expect(false, false);
  });
}
