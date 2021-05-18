import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Store {
  static Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<void> saveMap(String key, Map<String, dynamic> map) async {
    await saveString(key, json.encode(map));
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();

    final result = prefs.getString(key);

    return result;
  }

  static Future<Map<String, dynamic>?> getMap(String key) async {
    final result = await getString(key);

    if (result != null) {
      return json.decode(result);
    }
  }

  static Future<String?> deleteKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
