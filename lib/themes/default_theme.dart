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
    labelTextStyle: TextStyleScheme(
      heading1: const TextStyle(
        fontSize: 32,
        height: 1.25, // 40 / 32,
        fontWeight: FontWeight.w600,
        color: Color(0xFF15141E),
      ),
      heading4: const TextStyle(
        fontSize: 18,
        height: 1.33, // 24 / 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF000000),
      ),
      bodySmallRegular: const TextStyle(
        fontSize: 14,
        height: 1.285, // 18 / 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF56555E),
      ),
      bodyLargeRegular: const TextStyle(
        fontSize: 16,
        height: 1.5, // 24 / 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF15141E),
      ),
      labelSmall: const TextStyle(
        fontSize: 14,
        height: 1.285, // 18 / 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF56555E),
      ),
      labelMedium: const TextStyle(
        fontSize: 16,
        height: 1.5, // 24 / 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF15141E),
      ),
      labelLarge: const TextStyle(
        fontSize: 18,
        height: 1.33, // 24 / 18,
        fontWeight: FontWeight.w600,
      ),
      mixedStyles: const TextStyle(
        fontSize: 14,
        height: 1.285, // 18 / 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF15141E),
      ),
    ),
  );
}

class PorscheTheme {
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
    labelTextStyle: TextStyleScheme(
      heading1: const TextStyle(
        fontSize: 32,
        height: 1.25, // 40 / 32,
        fontWeight: FontWeight.w600,
        color: Color(0xFF15141E),
      ),
      heading4: const TextStyle(
        fontSize: 16,
        height: 1.5, // 24 / 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF000000),
      ),
      bodySmallRegular: const TextStyle(
        fontSize: 14,
        height: 1.285, // 18 / 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF56555E),
      ),
      bodyLargeRegular: const TextStyle(
        fontSize: 16,
        height: 1.5, // 24 / 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF15141E),
      ),
      labelSmall: const TextStyle(
        fontSize: 14,
        height: 1.285, // 18 / 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF56555E),
      ),
      labelMedium: const TextStyle(
        fontSize: 14,
        height: 1.285, // 18 / 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF56555E),
      ),
      labelLarge: const TextStyle(
        fontSize: 18,
        height: 1.33, // 24 / 18,
        fontWeight: FontWeight.w600,
      ),
      mixedStyles: const TextStyle(
        fontSize: 14,
        height: 1.285, // 18 / 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF15141E),
      ),
    ),
  );
}

class TextStyleScheme {
  final TextStyle heading1;
  final TextStyle heading4;
  final TextStyle bodySmallRegular;
  final TextStyle bodyLargeRegular;
  final TextStyle labelSmall;
  final TextStyle labelMedium;
  final TextStyle labelLarge;
  final TextStyle mixedStyles;

  TextStyleScheme({
    required this.heading1,
    required this.heading4,
    required this.bodySmallRegular,
    required this.bodyLargeRegular,
    required this.labelSmall,
    required this.labelMedium,
    required this.labelLarge,
    required this.mixedStyles,
  });
}

class ClientUiSettings {
  final ColorScheme colorscheme;
  final ThemeData themeData;
  final CustomClientUiSettings customSettings;
  final TextStyleScheme labelTextStyle;

  const ClientUiSettings({
    required this.colorscheme,
    required this.themeData,
    required this.customSettings,
    required this.labelTextStyle,
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
