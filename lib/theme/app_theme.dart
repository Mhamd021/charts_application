import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white, colorScheme: ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.lightBlueAccent,
      background: Colors.white,
      surface: Colors.grey[200]!,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
    ).copyWith(background: Colors.white),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blueGrey,
    scaffoldBackgroundColor: Colors.black, colorScheme: ColorScheme.dark(
      primary: Colors.blueGrey,
      secondary: Colors.cyanAccent,
      background: Colors.black,
      surface: Colors.grey[800]!,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
    ).copyWith(background: Colors.black),
  );
}
