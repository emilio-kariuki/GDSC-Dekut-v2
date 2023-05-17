import 'package:gdsc_bloc/Util/global_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(IS_LOGGED_IN) ?? false;
  }

  Future<bool> setLoggedIn({required bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(IS_LOGGED_IN, value);
  }

  Future<String> getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(ID) ?? '';
  }

  Future<bool> setId({required String value}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(ID, value);
  }

  Future<String> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(NAME) ?? '';
  }

  Future<bool> setName({required String value}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(NAME, value);
  }
}
