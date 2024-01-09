import 'package:flutter/material.dart';
import 'package:solarisdemo/themes/default_theme.dart';

class EnfuceTheme {
  static ColorScheme colorScheme = DefaultTheme.colorScheme.copyWith();

  static ClientUiSettings clientUiSettings = DefaultTheme.clientUiSettings.copyWith();

  static ClientFeatureFlags featureFlags = DefaultTheme.featureFlags.copyWith(simplifiedLogin: true);
}
