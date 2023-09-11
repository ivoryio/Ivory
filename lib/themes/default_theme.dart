import 'package:flutter/material.dart';

class DefaultTheme {
  static ColorScheme colorScheme = const ColorScheme(
    primary: Color(0xFF071034),
    secondary: Color(0xFF2575FC),
    tertiary: Color(0xFF2575FC), // USE THIS FOR BUTTON BACKGROUNDS
    surface: Colors.white, // USE THIS FOR BUTTON TEXTS
    surfaceVariant: Color(0xFF1D26A7),//USED TO CALCULATE GRADIENT,
    outline: Color(0xFF6300BB),//ALSO USED TO CALCULATE GRADIENT,
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
        buttonColor: colorScheme.tertiary,
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
      display: const TextStyle(
        fontSize: 40,
        height: 1.2, // 48 / 48,
        fontWeight: FontWeight.w600,
        color: Color(0xFF15141E),
      ),
      heading1: const TextStyle(
        fontSize: 32,
        height: 1.25, // 40 / 32,
        fontWeight: FontWeight.w600,
        color: Color(0xFF15141E),
      ),
      heading2: const TextStyle(
        fontSize: 24,
        height: 1.33, // 32 / 24,
        fontWeight: FontWeight.w600,
        color: Color(0xFF15141E),
      ),
      heading3: const TextStyle(
        fontSize: 20,
        height: 1.4, // 28 / 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF15141E),
      ),
      heading4: const TextStyle(
        fontSize: 16,
        height: 1.5, // 24 / 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF15141E),
      ),
      bodySmallRegular: const TextStyle(
        fontSize: 14,
        height: 1.285, // 18 / 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF56555E),
      ),
      bodySmallBold: const TextStyle(
        fontSize: 14,
        height: 1.285, // 18 / 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF15141E),
      ),
      bodyLargeRegular: const TextStyle(
        fontSize: 16,
        height: 1.5, // 24 / 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF15141E),
      ),
      bodyLargeRegularBold: const TextStyle(
        fontSize: 16,
        height: 1.5, // 24 / 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF15141E),
      ),
      labelCaps: const TextStyle(
        fontSize: 12,
        height: 1.33, // 16 / 12,
        fontWeight: FontWeight.w600,
        color: Color(0xFF15141E),
      ),
      labelXSmall: const TextStyle(
        fontSize: 12,
        height: 1.5, // 18 / 12,
        fontWeight: FontWeight.w600,
        color: Color(0xFF56555E),
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
        color: Color(0xFF15141E),
      ),
      mixedStyles: const TextStyle(
        fontSize: 16,
        height: 1.5, // 24 / 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF15141E),
      ),
    ),
  );
}

class PorscheTheme {
  static ColorScheme colorScheme = DefaultTheme.colorScheme.copyWith(
      primary: Colors.black,
      secondary: const Color(0xFFCC0000),
      tertiary: Colors.black, // USE THIS FOR BUTTON BACKGROUNDS
      surface: Colors.white, // USE THIS FOR BUTTON TEXTS
      surfaceVariant: const Color(0xFF3D3D3D), //USED TO CALCULATE GRADIENT,
      outline: Colors.black, //ALSO USED TO CALCULATE GRADIENT,
  );

  static ClientUiSettings clientUiSettings = DefaultTheme.clientUiSettings.copyWith(colorscheme: colorScheme);
}

class SolarisTheme {
  static ColorScheme colorScheme = DefaultTheme.colorScheme.copyWith(
    primary: const Color(0xFF1D2637),
    secondary: const Color(0xFFFF6432),
    tertiary: const Color(0xFFFF6432), // USE THIS FOR BUTTON BACKGROUNDS
    surface: Colors.white, // USE THIS FOR BUTTON TEXTS
    surfaceVariant: const Color(0xFFF8623A),//USED TO CALCULATE GRADIENT,
    outline: const Color(0xFF9D2801), //ALSO USED TO CALCULATE GRADIENT,
  );

  static ClientUiSettings clientUiSettings = DefaultTheme.clientUiSettings.copyWith(colorscheme: colorScheme);
}

class TextStyleScheme {
  final TextStyle display;
  final TextStyle heading1;
  final TextStyle heading2;
  final TextStyle heading3;
  final TextStyle heading4;
  final TextStyle bodySmallRegular;
  final TextStyle bodySmallBold;
  final TextStyle bodyLargeRegular;
  final TextStyle bodyLargeRegularBold;
  final TextStyle labelCaps;
  final TextStyle labelXSmall;
  final TextStyle labelSmall;
  final TextStyle labelMedium;
  final TextStyle labelLarge;
  final TextStyle mixedStyles;

  TextStyleScheme({
    required this.display,
    required this.heading1,
    required this.heading2,
    required this.heading3,
    required this.heading4,
    required this.bodySmallRegular,
    required this.bodySmallBold,
    required this.bodyLargeRegular,
    required this.bodyLargeRegularBold,
    required this.labelCaps,
    required this.labelXSmall,
    required this.labelSmall,
    required this.labelMedium,
    required this.labelLarge,
    required this.mixedStyles,
  });

  TextStyleScheme copyWith({
    TextStyle? display,
    TextStyle? heading1,
    TextStyle? heading2,
    TextStyle? heading3,
    TextStyle? heading4,
    TextStyle? bodySmallRegular,
    TextStyle? bodySmallBold,
    TextStyle? bodyLargeRegular,
    TextStyle? bodyLargeRegularBold,
    TextStyle? labelCaps,
    TextStyle? labelXSmall,
    TextStyle? labelSmall,
    TextStyle? labelMedium,
    TextStyle? labelLarge,
    TextStyle? mixedStyles,
  }) {
    return TextStyleScheme(
      display: display ?? this.display,
      heading1: heading1 ?? this.heading1,
      heading2: heading2 ?? this.heading2,
      heading3: heading3 ?? this.heading3,
      heading4: heading4 ?? this.heading4,
      bodySmallRegular: bodySmallRegular ?? this.bodySmallRegular,
      bodySmallBold: bodySmallBold ?? this.bodySmallBold,
      bodyLargeRegular: bodyLargeRegular ?? this.bodyLargeRegular,
      bodyLargeRegularBold: bodyLargeRegularBold ?? this.bodyLargeRegularBold,
      labelCaps: labelCaps ?? this.labelCaps,
      labelXSmall: labelXSmall ?? this.labelXSmall,
      labelSmall: labelSmall ?? this.labelSmall,
      labelMedium: labelMedium ?? this.labelMedium,
      labelLarge: labelLarge ?? this.labelLarge,
      mixedStyles: mixedStyles ?? this.mixedStyles,
    );
  }
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

  ClientUiSettings copyWith(
      {ColorScheme? colorscheme,
      ThemeData? themeData,
      CustomClientUiSettings? customSettings,
      TextStyleScheme? labelTextStyle}) {
    return ClientUiSettings(
      colorscheme: colorscheme ?? this.colorscheme,
      themeData: themeData ?? this.themeData,
      customSettings: customSettings ?? this.customSettings,
      labelTextStyle: labelTextStyle ?? this.labelTextStyle,
    );
  }
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
