// ignore_for_file: constant_identifier_names

import 'package:flutter/cupertino.dart';

enum LanguageType { ENGLISH, ARABIC }

const ASSET_PATH_LOCALIZATION = "assets/translation";
const String ARABIC = "ar";
const String ENGLISH = "en";
const Locale ARABIC_LOCAL = Locale("ar", "SA");
const Locale ENGLISH_LOCAL = Locale("en", "US");

extension LanguageTypeExtension on LanguageType {
  String getValue() {
    switch (this) {
      case LanguageType.ENGLISH:
        return ENGLISH;
      case LanguageType.ARABIC:
        return ARABIC;
    }
  }
}
