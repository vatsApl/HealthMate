import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static const KEY_USER_LOGIN = "userLogIn";
  static const KEY_USER_ID = "userId";
  static const KEY_USER_ID_INT = "userIdInt";
  static const KEY_USER_TYPE = "userType";
  static const KEY_FIRST_NAME = "firstName";
  static const KEY_LAST_NAME = "lastName";
  static const KEY_CLIENT_NAME = "clientName";
  static const KEY_ROLE_NAME = "roleName";
  static const KEY_EMAIL = "email";
  static const KEY_PHONE = "phone";
  static const KEY_AVATAR = "avatar";
  static const KEY_CLIENT_AVATAR = "clientAvatar";
  static const KEY_CV = "cv";
  static const KEYCandidateFirstName = 'candidate_fname';
  static const KEYCandidateLastName = 'candidate_fname';

  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences?> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance;
  }

  static String getString(String key, [String? defValue]) {
    return _prefsInstance?.getString(key) ?? defValue ?? "";
  }

  static Future<bool> setString(String key, String value) async {
    var prefs = await _instance;
    return prefs.setString(key, value);
  }

  static int getInt(String key, [int? defValue]) {
    return _prefsInstance?.getInt(key) ?? defValue ?? 0;
  }

  static Future<bool> setInt(String key, int value) async {
    var prefs = await _instance;
    return prefs.setInt(key, value);
  }

  static bool? getBool(String key, [bool? defValue]) {
    return _prefsInstance?.getBool(key) ?? defValue ?? false;
  }

  static Future<bool> setBool(String key, bool value) async {
    var prefs = await _instance;
    return prefs.setBool(key, value);
  }
}
