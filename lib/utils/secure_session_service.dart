import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureSessionService {
  static const FlutterSecureStorage _storage =
  FlutterSecureStorage();

  static const String _sessionKey = 'USER_SESSION';

  /// Simpan seluruh data login
  static Future<void> saveSession(Map<String, dynamic> data) async {
    await _storage.write(
      key: _sessionKey,
      value: jsonEncode(data),
    );
  }

  /// Ambil session
  static Future<Map<String, dynamic>?> getSession() async {
    final value = await _storage.read(key: _sessionKey);
    if (value == null) return null;
    return jsonDecode(value);
  }

  /// Cek login
  static Future<bool> isLogin() async {
    return await _storage.containsKey(key: _sessionKey);
  }

  /// Logout
  static Future<void> clear() async {
    await _storage.delete(key: _sessionKey);
  }
}
