import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const ColorScheme defaultColorScheme = ColorScheme(
  primary: Colors.white,
  secondary: Color(0xFF1C1A28),
  surface: Colors.white,
  background: Colors.white,
  error: Colors.red,
  onPrimary: Colors.black,
  onSecondary: Colors.black,
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
    iconTheme: const IconThemeData(color: Colors.white),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: defaultColorScheme.secondary,
    textTheme: ButtonTextTheme.primary,
  ),
);

final cupertinoTheme = CupertinoThemeData(
  primaryColor: defaultColorScheme.primary,
  scaffoldBackgroundColor: defaultColorScheme.background,
  barBackgroundColor: defaultColorScheme.surface,
  primaryContrastingColor: defaultColorScheme.onPrimary,
  brightness: Brightness.light,
  textTheme: CupertinoTextThemeData(
    primaryColor: defaultColorScheme.primary,
    textStyle: const TextStyle(
      fontFamily: 'Proxima Nova',
      color: Colors.black,
    ),
  ),
);
