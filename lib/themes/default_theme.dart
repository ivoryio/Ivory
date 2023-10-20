import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';

enum CardType { visa, mastercard }

class DefaultTheme {
  static ColorScheme colorScheme = const ColorScheme(
    primary: Color(0xFF071034),
    secondary: Color(0xFF2575FC),
    tertiary: Color(0xFF2575FC), // USE THIS FOR BUTTON BACKGROUNDS
    surface: Colors.white, // USE THIS FOR BUTTON TEXTS
    surfaceVariant: Color(0xFF1D26A7), //USED TO CALCULATE GRADIENT,
    outline: Color(0xFF6300BB), //ALSO USED TO CALCULATE GRADIENT,
    background: Colors.white,
    error: Color(0xFFE61F27),
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  );

  static ClientUiSettings clientUiSettings = ClientUiSettings(
    customColors: const CustomColors(
      neutral100: Color(0xFFF8F9FA),
      neutral200: Color(0xFFE9EAEB),
      neutral300: Color(0xFFDFE2E6),
      neutral400: Color(0xFFCFD4D9),
      neutral500: Color(0xFFADADB4),
      neutral600: Color(0xFF757480),
      neutral700: Color(0xFF56555E),
      neutral800: Color(0xFF313038),
      neutral900: Color(0xFF15141E),
      success: Color(0xFF00774C),
      red100: Color(0xFFFFE9EA),
    ),
    cardType: CardType.visa,
    welcomeVideoPath: "assets/videos/ivory_welcome_video.mp4",
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
      defaultScreenTopPadding: 0,
      defaultScreenBottomPadding: 16,
      defaultScreenLeftPadding: 24,
      defaultScreenRightPadding: 24,
      defaultScreenHorizontalPadding: const EdgeInsets.symmetric(horizontal: 24),
      defaultScreenVerticalPadding: const EdgeInsets.only(top: 0, bottom: 16),
      defaultScreenPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
    ),
    labelTextStyle: TextStyleScheme(
      display: TextStyle(
        fontSize: 40,
        height: 1.2, // 48 / 48,
        fontWeight: FontWeight.w600,
        color: ClientConfig.getCustomColors().neutral900,
      ),
      heading1: TextStyle(
        fontSize: 32,
        height: 1.25, // 40 / 32,
        fontWeight: FontWeight.w600,
        color: ClientConfig.getCustomColors().neutral900,
      ),
      heading2: TextStyle(
        fontSize: 24,
        height: 1.33, // 32 / 24,
        fontWeight: FontWeight.w600,
        color: ClientConfig.getCustomColors().neutral900,
      ),
      heading3: TextStyle(
        fontSize: 20,
        height: 1.4, // 28 / 20,
        fontWeight: FontWeight.w600,
        color: ClientConfig.getCustomColors().neutral900,
      ),
      heading4: TextStyle(
        fontSize: 16,
        height: 1.5, // 24 / 16,
        fontWeight: FontWeight.w600,
        color: ClientConfig.getCustomColors().neutral900,
      ),
      bodySmallRegular: TextStyle(
        fontSize: 14,
        height: 1.285, // 18 / 14,
        fontWeight: FontWeight.w400,
        color: ClientConfig.getCustomColors().neutral700,
      ),
      bodySmallBold: TextStyle(
        fontSize: 14,
        height: 1.285, // 18 / 14,
        fontWeight: FontWeight.w600,
        color: ClientConfig.getCustomColors().neutral900,
      ),
      bodyLargeRegular: TextStyle(
        fontSize: 16,
        height: 1.5, // 24 / 16,
        fontWeight: FontWeight.w400,
        color: ClientConfig.getCustomColors().neutral900,
      ),
      bodyLargeRegularBold: TextStyle(
        fontSize: 16,
        height: 1.5, // 24 / 16,
        fontWeight: FontWeight.w600,
        color: ClientConfig.getCustomColors().neutral900,
      ),
      labelCaps: TextStyle(
        fontSize: 12,
        height: 1.33, // 16 / 12,
        fontWeight: FontWeight.w600,
        color: ClientConfig.getCustomColors().neutral900,
      ),
      labelXSmall: TextStyle(
        fontSize: 12,
        height: 1.5, // 18 / 12,
        fontWeight: FontWeight.w600,
        color: ClientConfig.getCustomColors().neutral700,
      ),
      labelSmall: TextStyle(
        fontSize: 14,
        height: 1.285, // 18 / 14,
        fontWeight: FontWeight.w600,
        color: ClientConfig.getCustomColors().neutral700,
      ),
      labelMedium: TextStyle(
        fontSize: 16,
        height: 1.5, // 24 / 16,
        fontWeight: FontWeight.w600,
        color: ClientConfig.getCustomColors().neutral900,
      ),
      labelLarge: TextStyle(
        fontSize: 18,
        height: 1.33, // 24 / 18,
        fontWeight: FontWeight.w600,
        color: ClientConfig.getCustomColors().neutral900,
      ),
      mixedStyles: TextStyle(
        fontSize: 16,
        height: 1.5, // 24 / 16,
        fontWeight: FontWeight.w400,
        color: ClientConfig.getCustomColors().neutral900,
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

  static ClientUiSettings clientUiSettings = DefaultTheme.clientUiSettings.copyWith(
    colorscheme: colorScheme,
    cardType: CardType.mastercard,
    welcomeVideoPath: "assets/videos/porsche_welcome_video.mp4",
  );
}

class SolarisTheme {
  static ColorScheme colorScheme = DefaultTheme.colorScheme.copyWith(
    primary: const Color(0xFF1D2637),
    secondary: const Color(0xFFFF6432),
    tertiary: const Color(0xFFFF6432), // USE THIS FOR BUTTON BACKGROUNDS
    surface: Colors.white, // USE THIS FOR BUTTON TEXTS
    surfaceVariant: const Color(0xFFF8623A), //USED TO CALCULATE GRADIENT,
    outline: const Color(0xFF9D2801), //ALSO USED TO CALCULATE GRADIENT,
  );

  static ClientUiSettings clientUiSettings = DefaultTheme.clientUiSettings.copyWith(colorscheme: colorScheme);
}

class CustomColors {
  final Color neutral100;
  final Color neutral200;
  final Color neutral300;
  final Color neutral400;
  final Color neutral500;
  final Color neutral600;
  final Color neutral700;
  final Color neutral800;
  final Color neutral900;
  final Color success;
  final Color red100;

  const CustomColors({
    required this.neutral100,
    required this.neutral200,
    required this.neutral300,
    required this.neutral400,
    required this.neutral500,
    required this.neutral600,
    required this.neutral700,
    required this.neutral800,
    required this.neutral900,
    required this.success,
    required this.red100,
  });

  CustomColors copyWith({
    Color? neutral100,
    Color? neutral200,
    Color? neutral300,
    Color? neutral400,
    Color? neutral500,
    Color? neutral600,
    Color? neutral700,
    Color? neutral800,
    Color? neutral900,
    Color? success,
    Color? red100,
  }) {
    return CustomColors(
      neutral100: neutral100 ?? this.neutral100,
      neutral200: neutral200 ?? this.neutral200,
      neutral300: neutral300 ?? this.neutral300,
      neutral400: neutral400 ?? this.neutral400,
      neutral500: neutral500 ?? this.neutral500,
      neutral600: neutral600 ?? this.neutral600,
      neutral700: neutral700 ?? this.neutral700,
      neutral800: neutral800 ?? this.neutral800,
      neutral900: neutral900 ?? this.neutral900,
      success: success ?? this.success,
      red100: red100 ?? this.red100,
    );
  }
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
  final CustomColors customColors;
  final ThemeData themeData;
  final CustomClientUiSettings customSettings;
  final TextStyleScheme labelTextStyle;
  final CardType cardType;
  final String welcomeVideoPath;

  const ClientUiSettings({
    required this.colorscheme,
    required this.customColors,
    required this.themeData,
    required this.customSettings,
    required this.labelTextStyle,
    required this.cardType,
    required this.welcomeVideoPath,
  });

  ClientUiSettings copyWith({
    ColorScheme? colorscheme,
    CustomColors? customColors,
    ThemeData? themeData,
    CustomClientUiSettings? customSettings,
    TextStyleScheme? labelTextStyle,
    CardType? cardType,
    String? welcomeVideoPath,
  }) {
    return ClientUiSettings(
      colorscheme: colorscheme ?? this.colorscheme,
      customColors: customColors ?? this.customColors,
      themeData: themeData ?? this.themeData,
      customSettings: customSettings ?? this.customSettings,
      labelTextStyle: labelTextStyle ?? this.labelTextStyle,
      cardType: cardType ?? this.cardType,
      welcomeVideoPath: welcomeVideoPath ?? this.welcomeVideoPath,
    );
  }
}

class CustomClientUiSettings {
  final double defaultScreenTopPadding;
  final double defaultScreenBottomPadding;
  final double defaultScreenLeftPadding;
  final double defaultScreenRightPadding;
  final EdgeInsets defaultScreenHorizontalPadding;
  final EdgeInsets defaultScreenVerticalPadding;
  final EdgeInsets defaultScreenPadding;

  CustomClientUiSettings({
    required this.defaultScreenTopPadding,
    required this.defaultScreenBottomPadding,
    required this.defaultScreenLeftPadding,
    required this.defaultScreenRightPadding,
    required this.defaultScreenHorizontalPadding,
    required this.defaultScreenVerticalPadding,
    required this.defaultScreenPadding,
  });
}
