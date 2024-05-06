import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static Future<int> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 1; // Default or throw an exception if no user
  }
}
