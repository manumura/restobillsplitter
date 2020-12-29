import 'package:flutter/material.dart';

final ThemeData _androidTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.amber,
  accentColor: Colors.grey,
  buttonColor: Colors.grey,
  fontFamily: 'Raleway',
  inputDecorationTheme: InputDecorationTheme(
    errorStyle: const TextStyle(
      color: Colors.red,
    ),
    hintStyle: TextStyle(
      color: Colors.indigo[100],
    ),
  ),
  textTheme: const TextTheme(
    headline6: TextStyle(
      color: Colors.white,
    ),
  ),
  scaffoldBackgroundColor: Colors.grey[300],
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

final ThemeData _iOSTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.grey,
  accentColor: Colors.blue,
  buttonColor: Colors.blue,
  fontFamily: 'Raleway',
  inputDecorationTheme: InputDecorationTheme(
    errorStyle: const TextStyle(
      color: Colors.red,
    ),
    hintStyle: TextStyle(
      color: Colors.indigo[100],
    ),
  ),
  textTheme: const TextTheme(
    headline6: TextStyle(
      color: Colors.white,
    ),
  ),
  scaffoldBackgroundColor: Colors.grey[200],
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData getAdaptiveThemeData(BuildContext context) {
  return Theme.of(context).platform == TargetPlatform.android
      ? _androidTheme
      : _iOSTheme;
}
