import 'package:shared_preferences/shared_preferences.dart';

/// Constants for SharedPreferences keys
class PrefConstants {
  static String userToken = 'userToken';
  static String firstTimeLogin = 'firstTimeLogin';
  static String verificationStatus = 'verification_image';
  static String userRole = 'userRole';
  static String loginUserId = 'loginUserId';
}

/// Class for handling local storage using SharedPreferences
class LocalStorage {
  /// Instance variable to hold SharedPreferences instance
  SharedPreferences? prefs;

  /// Static variable to hold the singleton instance of LocalStorage
  static final LocalStorage _instance = LocalStorage._internal();

  /// Singleton pattern for LocalStorage
  factory LocalStorage() {
    return _instance;
  }

  LocalStorage._internal() {
    /// Initialize SharedPreferences when the instance is created
    initialize();
  }

  /// Getter for accessing the instance of LocalStorage
  static LocalStorage get instance {
    _instance.initialize();
    return _instance;
  }

  /// Initialize SharedPreferences
  Future<void> initialize() async =>
      prefs ??= await SharedPreferences.getInstance();

  /// Get a string value from SharedPreferences
  String? getString(String key) => prefs?.getString(key);

  /// Remove a single key-value pair from SharedPreferences
  Future<bool?> removeOnly(String key) async => await prefs?.remove(key);

  /// Set a string value in SharedPreferences
  Future<bool?> setString({
    required String key,
    required String value,
  }) async =>
      await prefs?.setString(key, value);

  /// Remove all SharedPreferences keys except 'firstTimeLogin'
  Future<void> remove() async {
    Set<String>? keys = prefs?.getKeys();
    for (var prefsKeys in (keys ?? {})) {
      if (prefsKeys != PrefConstants.firstTimeLogin) {
        await prefs?.remove(prefsKeys);
      }
    }
  }
}
