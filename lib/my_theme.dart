import 'package:flutter/material.dart';

import 'shared/styles/colors.dart';

class MyThemeData {
  static ThemeData lightTheme = ThemeData(
      primaryColor: colorWhite,
      scaffoldBackgroundColor: colorLightGreen,
      colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: colorWhite,
          onPrimary: colorGrey,
          secondary: colorWhite,
          onSecondary: colorLightBlue,
          error: Colors.red,
          onError: colorWhite,
          background: colorBrightGreen,
          onBackground: colorLightGreen,
          surface: Colors.grey,
          onSurface: colorWhite),
      appBarTheme: const AppBarTheme(
          backgroundColor: colorLightBlue,
          iconTheme: IconThemeData(color: colorWhite)),
      textTheme: const TextTheme(
          //use headlines for appbar titles or stuff like that
          headline1: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: colorWhite,
          ),
          //user subtitles for other texts like paragraph texts
          subtitle1: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorLightBlue,
          ),
          subtitle2: TextStyle(
            fontSize: 18,
            color: colorBrightGreen,
          )),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: colorWhite,
          selectedItemColor: colorLightBlue,
          unselectedItemColor: Colors.grey));

  static ThemeData darkTheme = ThemeData(
      primaryColor: colorDarkBlue,
      scaffoldBackgroundColor: colorLightGreen,
      colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: colorDarkBlue,
          onPrimary: colorWhite,
          secondary: colorLighterDarkBlue,
          onSecondary: colorLightBlue,
          error: Colors.red,
          onError: colorWhite,
          background: colorBrightGreen,
          onBackground: colorLightGreen,
          surface: Colors.grey,
          onSurface: colorWhite),
      appBarTheme: const AppBarTheme(
          backgroundColor: colorLightBlue,
          iconTheme: IconThemeData(color: colorDarkBlue)),
      textTheme: const TextTheme(
          //use headlines for appbar titles or stuff like that
          headline1: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: colorDarkBlue,
          ),
          //user subtitles for other texts like paragraph texts
          subtitle1: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorLightBlue,
          ),
          subtitle2: TextStyle(
            fontSize: 18,
            color: colorBrightGreen,
          )),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: colorLighterDarkBlue,
          selectedItemColor: colorLightBlue,
          unselectedItemColor: Colors.grey));
}
