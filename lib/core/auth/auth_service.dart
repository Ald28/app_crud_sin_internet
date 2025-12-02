import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<void> saveSession({
    required String token,
    required String userId,
    required String role,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("token", token);
    await prefs.setString("userId", userId);
    await prefs.setString("role", role);
    await prefs.setString("email", email);
  }

  static Future<Map<String, dynamic>> loadSession() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "token": prefs.getString("token"),
      "userId": prefs.getString("userId"),
      "role": prefs.getString("role"),
      "email": prefs.getString("email"),
    };
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}