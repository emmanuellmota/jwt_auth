import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_auth/models/jwt_token.dart';

// AndroidOptions _getAndroidOptions() => const AndroidOptions(
//       encryptedSharedPreferences: true,
//     );
//     aOptions: _getAndroidOptions()

class JwtAuthStorage {
  static const String jwtTokenKeyStorage = 'jwt_token';

  final storage = const FlutterSecureStorage();

  JwtAuthStorage();

  saveJwtToken(JwtToken jwtToken) async {
    var jwtTokenString = JwtToken.serialize(jwtToken);
    await storage.write(key: jwtTokenKeyStorage, value: jwtTokenString);
  }

  Future<JwtToken?> getJwtToken() async {
    var jwtTokenString = await storage.read(key: jwtTokenKeyStorage);
    if (jwtTokenString == null) return null;

    return JwtToken.deserialize(jwtTokenString);
  }

  deleteJwtToken() async {
    await storage.delete(key: jwtTokenKeyStorage);
  }
}
