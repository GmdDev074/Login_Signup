import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLoginState(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', token); // Save token or any identifier
  await prefs.setBool('isLoggedIn', true); // Optional: Track login state
}