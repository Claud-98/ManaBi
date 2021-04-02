import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static final String romajiKey = "romaji";

  static Future<SharedPreferences> getSharedPreferencesInstance() async {
    return await SharedPreferences.getInstance();
  }
  static void saveKV(String key, dynamic value) async {
    SharedPreferences sharedPreferences = await getSharedPreferencesInstance();
    if (value is bool) {
      sharedPreferences.setBool(key, value);
    } else if (value is String) {
      sharedPreferences.setString(key, value);
    } else if (value is int) {
      sharedPreferences.setInt(key, value);
    } else if (value is double) {
      sharedPreferences.setDouble(key, value);
    } else if (value is List<String>) {
      sharedPreferences.setStringList(key, value);
    }
  }

  static Future<SharedPreferences> getSharedPreferencesItem(String key) async {
    SharedPreferences sharedPreferences = await getSharedPreferencesInstance();
    return sharedPreferences.get(key);
  }

  static bool getSharedPreferencesItemValue(String key){
    Future future = getSharedPreferencesItem(key);

    FutureBuilder(future: future,
        builder: (context, snapshot){
          if (snapshot.hasData)
            return snapshot.data;
          return null;
        });
    return null;
  }

  static void resetSharedPreferences(List<String> list) async{
    SharedPreferences sharedPreferences = await getSharedPreferencesInstance();
    for(String key in list)
      sharedPreferences.remove(key);
  }
}