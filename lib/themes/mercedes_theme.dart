import 'package:flutter/material.dart';
import 'package:solarisdemo/themes/default_theme.dart';

class MercedesTheme {
  static ColorScheme colorScheme = DefaultTheme.colorScheme.copyWith(
    primary: Colors.black,
    secondary: const Color(0xFF00ADEF),
    tertiary: const Color(0xFF00ADEF), // USE THIS FOR BUTTON BACKGROUNDS
    surface: Colors.white, // USE THIS FOR BUTTON TEXTS
    surfaceVariant: const Color(0xFF363636), //USED TO CALCULATE GRADIENT,
    outline: Colors.black, //ALSO USED TO CALCULATE GRADIENT,
  );

  static ClientUiSettings clientUiSettings = DefaultTheme.clientUiSettings.copyWith(
    colorscheme: colorScheme,
    cardType: CardType.mastercard,
    welcomeVideoPath: "assets/videos/mercedes_welcome_video.mp4",
  );
}
