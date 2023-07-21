import 'package:flutter/material.dart';

class DefaultTheme {
  static ColorScheme colorScheme = const ColorScheme(
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

  static ClientUiSettings clientUiSettings = ClientUiSettings(
    colorscheme: colorScheme,
    themeData: ThemeData(
      primaryColor: colorScheme.primary,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      fontFamily: 'Proxima Nova',
      appBarTheme: AppBarTheme(
        color: colorScheme.surface,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
          fontFamily: 'Proxima Nova',
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: colorScheme.primary,
        textTheme: ButtonTextTheme.normal,
      ),
    ),
    customSettings: CustomClientUiSettings(
      defaultScreenHorizontalPadding: 24,
      defaultScreenVerticalPadding: 24,
      defaultScreenPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 24,
      ),
    ),
  );
}

class PorscheTheme {
  static ColorScheme colorScheme = const ColorScheme(
    primary: Colors.blue,
    secondary: Colors.red,
    surface: Colors.black,
    background: Colors.black,
    error: Colors.green,
    onPrimary: Colors.green,
    onSecondary: Colors.black,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  );

  static ClientUiSettings clientUiSettings = ClientUiSettings(
    colorscheme: const ColorScheme(
      primary: Colors.blue,
      secondary: Colors.red,
      surface: Colors.black,
      background: Colors.black,
      error: Colors.green,
      onPrimary: Colors.green,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    themeData: ThemeData(
      primaryColor: colorScheme.primary,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      fontFamily: 'Proxima Nova',
      appBarTheme: AppBarTheme(
        color: colorScheme.surface,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
          fontFamily: 'Proxima Nova',
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: colorScheme.primary,
        textTheme: ButtonTextTheme.normal,
      ),
    ),
    customSettings: CustomClientUiSettings(
      defaultScreenHorizontalPadding: 24,
      defaultScreenVerticalPadding: 24,
      defaultScreenPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 24,
      ),
    ),
  );
}

class ClientUiSettings {
  final ColorScheme colorscheme;
  final ThemeData themeData;
  final CustomClientUiSettings customSettings;

  const ClientUiSettings({
    required this.colorscheme,
    required this.themeData,
    required this.customSettings,
  });
}

class CustomClientUiSettings {
  final double defaultScreenHorizontalPadding;
  final double defaultScreenVerticalPadding;
  final EdgeInsets defaultScreenPadding;

  CustomClientUiSettings({
    required this.defaultScreenHorizontalPadding,
    required this.defaultScreenVerticalPadding,
    required this.defaultScreenPadding,
  });
}
