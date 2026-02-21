import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Tokens {
  static String? _token;

  static Future<String?> get token async {
    if (Tokens._token != null) return Tokens._token;
    final storage = FlutterSecureStorage();
    Tokens._token = await storage.read(key: "token");
    return Tokens._token;
  }

  static save(token) async {
    Tokens._token = token;
    final storage = FlutterSecureStorage();
    await storage.write(key: "token", value: token);
  }

  static clear() async {
    _token = null;
    final storage = FlutterSecureStorage();
    await storage.delete(key: "token");
  }
}
