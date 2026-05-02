import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorageServices {
  static SharedPreferences? _preferences;

  static Future<SharedPreferences> get instance async => _preferences ??= await SharedPreferences.getInstance();

  static Future<bool> saveData<T>(String key, T value) async {
    final prefs = await instance;
    if (prefs.containsKey(key)) {
      await deleteData(key);
    }
    if (T == String) {
      return await prefs.setString(key, value as String);
    } else if (T == int) {
      return await prefs.setInt(key, value as int);
    } else if (T == bool) {
      return await prefs.setBool(key, value as bool);
    } else if (T == List<String>) {
      return await prefs.setStringList(key, value as List<String>);
    } else {
      return await prefs.setString(key, jsonEncode(value));
    }
  }

  static T? getData<T>(String key) {
    final prefs = _preferences;
    if (prefs == null) return null;
    
    if (T == String) {
      return prefs.getString(key) as T?;
    } else if (T == int) {
      return prefs.getInt(key) as T?;
    } else if (T == bool) {
      return prefs.getBool(key) as T?;
    } else if (T == List<String>) {
      return prefs.getStringList(key) as T?;
    } else {
      final jsonString = prefs.getString(key);
      if (jsonString != null) return jsonDecode(jsonString) as T?;
    }
    return null;
  }

  static Future<bool> clearAll() async {
    final prefs = await instance;
    return await prefs.clear();
  }

  static Future<bool> deleteData(String key) async {
    final prefs = await instance;
    if (prefs.containsKey(key)) {
      return await prefs.remove(key);
    }
    return false;
  }

  static String? getToken() => getData<String>(LocalStorageKeys.token.name);
  static Future<bool> saveToken(String token) => saveData(LocalStorageKeys.token.name, token);

  static String getUserId() => getData<String>(LocalStorageKeys.userId.name) ?? '';
  static Future<bool> saveUserId(String userId) => saveData(LocalStorageKeys.userId.name, userId);
  
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }
}

enum LocalStorageKeys { token, userId }
