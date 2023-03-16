import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const ColorScheme defaultColorScheme = ColorScheme(
  primary: Colors.black,
  secondary: Colors.white,
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
      color: defaultColorScheme.surface,
      iconTheme: IconThemeData(color: defaultColorScheme.onSurface),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: defaultColorScheme.primary,
      textTheme: ButtonTextTheme.normal,
    ),
    cupertinoOverrideTheme: CupertinoThemeData(
      primaryColor: defaultColorScheme.primary,
      brightness: Brightness.light,
      textTheme: CupertinoTextThemeData(
        primaryColor: Colors.white,
        textStyle: TextStyle(
          fontFamily: 'Proxima Nova',
          color: defaultColorScheme.primary,
        ),
      ),
    ));

final cupertinoTheme =
    MaterialBasedCupertinoThemeData(materialTheme: defaultMaterialTheme);
