import 'package:flutter/material.dart';

final ThemeData _androidTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.amber,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.amber,
    accentColor: Colors.grey,
  ).copyWith(secondary: Colors.grey),
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
    titleLarge: TextStyle(
      color: Colors.white,
    ),
  ),
  scaffoldBackgroundColor: Colors.grey[300],
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

final ThemeData _iOSTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.grey,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.grey,
    accentColor: Colors.blue,
  ).copyWith(secondary: Colors.blue),
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
    titleLarge: TextStyle(
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
