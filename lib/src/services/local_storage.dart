import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences prefs;

  static Future<void> configurePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveIdUser(String id) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('isUser', id);
  }

  static Future<String?> getIdUser() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString('isUser');
  }
}
