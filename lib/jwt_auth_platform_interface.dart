import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'jwt_auth_method_channel.dart';

abstract class JwtAuthPlatform extends PlatformInterface {
  /// Constructs a JwtAuthPlatform.
  JwtAuthPlatform() : super(token: _token);

  static final Object _token = Object();

  static JwtAuthPlatform _instance = MethodChannelJwtAuth();

  /// The default instance of [JwtAuthPlatform] to use.
  ///
  /// Defaults to [MethodChannelJwtAuth].
  static JwtAuthPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [JwtAuthPlatform] when
  /// they register themselves.
  static set instance(JwtAuthPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
