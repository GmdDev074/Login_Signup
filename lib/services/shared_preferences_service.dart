import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _uidKey = 'uid';
  static const String _emailKey = 'email';

  // Save user state
  Future<void> saveUserState({
    required String uid,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_uidKey, uid);
    await prefs.setString(_emailKey, email);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Get user data
  Future<Map<String, String>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString(_uidKey);
    final email = prefs.getString(_emailKey);
    if (uid != null && email != null) {
      return {'uid': uid, 'email': email};
    }
    return null;
  }

  // Clear user state (logout)
  Future<void> clearUserState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_uidKey);
    await prefs.remove(_emailKey);
  }
}