import 'package:flutter/material.dart';
import 'package:smart_school/service/language_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static Locale getInitLocale() {
    // return mpaLanguageCodeToLocale[LangCode.ar.name]!;
    final deviceLanguage = WidgetsBinding.instance.window.locale.languageCode;
    debugPrint(deviceLanguage);
    return mpaLanguageCodeToLocale[deviceLanguage] ?? defaultLocal;
  }

  static getUserId ()async{
    SharedPreferences shared = await SharedPreferences.getInstance();
    return shared.getInt('id')!;
  }
}
