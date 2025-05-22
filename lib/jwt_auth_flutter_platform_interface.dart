import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'jwt_auth_flutter_method_channel.dart';

abstract class JwtAuthFlutterPlatform extends PlatformInterface {
  /// Constructs a JwtAuthFlutterPlatform.
  JwtAuthFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static JwtAuthFlutterPlatform _instance = MethodChannelJwtAuthFlutter();

  /// The default instance of [JwtAuthFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelJwtAuthFlutter].
  static JwtAuthFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [JwtAuthFlutterPlatform] when
  /// they register themselves.
  static set instance(JwtAuthFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
