// ignore_for_file: constant_identifier_names

import 'package:clean_achitecture/presentation/resources/language_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String KEY_PREFS_LANG = "KEY_PREFS_LANG";
const String KEY_PREFS_ONBOARDING_SCREEN_VIEWED =
    "KEY_PREFS_ONBOARDING_SCREEN_VIEWED";
const String KEY_PREFS_IS_USER_LOGGED_IN = "KEY_PREFS_IS_USER_LOGGED_IN";

class AppPreferences {
  final SharedPreferences _sharedPreferences;
  AppPreferences(this._sharedPreferences);
  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(KEY_PREFS_LANG);
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      return LanguageType.ENGLISH.getValue();
    }
  }

  Future<void> changeAppLanguage() async {
    String currentLang = await getAppLanguage();
    if (currentLang == LanguageType.ARABIC.getValue()) {
      //set English
      _sharedPreferences.setString(
          KEY_PREFS_LANG, LanguageType.ENGLISH.getValue());
    } else {
      //set Arabic
      _sharedPreferences.setString(
          KEY_PREFS_LANG, LanguageType.ARABIC.getValue());
    }
  }

  Future<Locale> getLocale() async {
    String currentLang = await getAppLanguage();
    if (currentLang == LanguageType.ARABIC.getValue()) {
      return ARABIC_LOCAL;
    } else {
      return ENGLISH_LOCAL;
    }
  }

  //on Boarding
  Future<void> setOnBoardingScreenViewed() async {
    _sharedPreferences.setBool(KEY_PREFS_ONBOARDING_SCREEN_VIEWED, true);
  }

  Future<bool> isOnBoardingScreenViewed() async {
    return _sharedPreferences.getBool(KEY_PREFS_ONBOARDING_SCREEN_VIEWED) ??
        false;
  }

  //Log in
  Future<void> setUserLoggedIn() async {
    _sharedPreferences.setBool(KEY_PREFS_IS_USER_LOGGED_IN, true);
  }

  //Log in
  Future<void> setUserLoggedOut() async {
    _sharedPreferences.remove(KEY_PREFS_IS_USER_LOGGED_IN);
    //_sharedPreferences.setBool(KEY_PREFS_IS_USER_LOGGED_IN, false);
  }

  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(KEY_PREFS_IS_USER_LOGGED_IN) ?? false;
  }
}
