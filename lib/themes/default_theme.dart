import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const ColorScheme defaultColorScheme = ColorScheme(
  primary: Colors.black,
  secondary: Color(0xffD9D9D9),
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
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontFamily: 'Proxima Nova',
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: defaultColorScheme.primary,
      textTheme: ButtonTextTheme.normal,
    ),
    cupertinoOverrideTheme: CupertinoThemeData(
      primaryColor: defaultColorScheme.primary,
      brightness: Brightness.light,
      barBackgroundColor: defaultColorScheme.surface,
      scaffoldBackgroundColor: defaultColorScheme.surface,
      textTheme: CupertinoTextThemeData(
        primaryColor: defaultColorScheme.primary,
        textStyle: TextStyle(
          fontFamily: 'Proxima Nova',
          color: defaultColorScheme.primary,
        ),
      ),
    ));

final cupertinoTheme =
    MaterialBasedCupertinoThemeData(materialTheme: defaultMaterialTheme);
