import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'jwt_auth_platform_interface.dart';

class MethodChannelJwtAuth extends JwtAuthPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('jwt_auth');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
