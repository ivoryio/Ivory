import 'package:flutter/material.dart';

const ColorScheme defaultColorScheme = ColorScheme(
  primary: Colors.black,
  secondary: Color(0xFF1C1A28),
  surface: Colors.white,
  background: Colors.white,
  error: Colors.red,
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onSurface: Colors.black,
  onBackground: Colors.black,
  onError: Colors.white,
  brightness: Brightness.light,
);

final ThemeData defaultMaterialTheme = ThemeData(
  primaryColor: defaultColorScheme.primary,
  colorScheme: defaultColorScheme,
  scaffoldBackgroundColor: defaultColorScheme.background,
  fontFamily: 'Proxima Nova',
  appBarTheme: AppBarTheme(
    color: defaultColorScheme.primary,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: defaultColorScheme.secondary,
    textTheme: ButtonTextTheme.primary,
  ),
);
