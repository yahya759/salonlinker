import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.bg,
      brightness: Brightness.dark,
    );
  }

  static List<LocalizationsDelegate<dynamic>> get localizationsDelegates => [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static Locale getLocale(String locale) => Locale(locale);

  static TextDirection getTextDirection(String locale) =>
      locale == 'ar' ? TextDirection.rtl : TextDirection.ltr;
}
