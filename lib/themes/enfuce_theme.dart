import 'package:flutter/material.dart';
import 'package:solarisdemo/themes/default_theme.dart';

class EnfuceTheme {
  static ColorScheme colorScheme = DefaultTheme.colorScheme.copyWith(
    primary: Colors.black,
    secondary: const Color(0xFF7640DE),
    tertiary: const Color(0xFFFFE600), // USE THIS FOR BUTTON BACKGROUNDS
    surface: Colors.white,
    surfaceVariant: const Color(0xFF12112E), //USED TO CALCULATE GRADIENT,
    outline: const Color(0xFF7640DE), //ALSO USED TO CALCULATE GRADIENT,
    onTertiary: const Color(0xFF12112E),
  );

  static ClientUiSettings clientUiSettings = DefaultTheme.clientUiSettings.copyWith(
    colorscheme: colorScheme,
    welcomeVideoPath: "assets/videos/enfuce_welcome_video.mp4",
  );

  static ClientFeatureFlags featureFlags = DefaultTheme.featureFlags.copyWith(simplifiedLogin: true);
}
