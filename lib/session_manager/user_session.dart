import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserSession {
  static UserModel? currentUser;

  /// Save user locally
  static Future<void> setUser(UserModel user) async {
    currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user", jsonEncode(user.toJson()));
  }

  /// Load user from local storage
  static Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString("user");

    if (userData != null) {
      currentUser = UserModel.fromJson(jsonDecode(userData));
    }
  }

  /// Clear user data
  static Future<void> clear() async {
    currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("user");
  }
}
