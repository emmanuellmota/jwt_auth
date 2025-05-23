import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'jwt_auth_flutter_platform_interface.dart';

/// An implementation of [JwtAuthFlutterPlatform] that uses method channels.
class MethodChannelJwtAuthFlutter extends JwtAuthFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('jwt_auth_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
