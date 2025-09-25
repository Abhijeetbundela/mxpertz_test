import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:mxpertz_test/core/constants/shared_prefs_keys.dart';
import 'package:mxpertz_test/domain/entities/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton()
class SharedPrefsHelper {
  SharedPrefsHelper(this._prefs);

  final SharedPreferences _prefs;

  Future<bool> saveUserEntity(UserEntity user) async {
    final Map<String, dynamic> jsonMap = <String, dynamic>{
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'phoneNumber': user.phoneNumber,
    };

    return _prefs.setString(SharedPrefsKeys.userKey, jsonEncode(jsonMap));
  }

  Map<String, dynamic>? _getUserJson() {
    final String? jsonString = _prefs.getString(SharedPrefsKeys.userKey);
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }

    final Object? decoded = jsonDecode(jsonString);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    return null;
  }

  UserEntity? getUserEntity() {
    final Map<String, dynamic>? jsonMap = _getUserJson();
    if (jsonMap == null) {
      return null;
    }

    return UserEntity(
      id: (jsonMap['id'] ?? '').toString(),
      name: (jsonMap['name'] ?? '').toString(),
      email: (jsonMap['email'] ?? '').toString(),
      phoneNumber: (jsonMap['phoneNumber'] ?? '').toString(),
    );
  }

  Future<bool> clear() async {
    return _prefs.clear();
  }

  Future<bool> setString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  String getString(String key) {
    return _prefs.getString(key) ?? '';
  }

  Future<bool> setBool(String key, bool value) async {
    return _prefs.setBool(key, value);
  }

  bool getBool(String key) {
    return _prefs.getBool(key) ?? false;
  }
}
