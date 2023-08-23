// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart';

import 'themes/default_theme.dart';

class Config {
  static String cognitoUserPoolId = dotenv.env['COGNITO_USER_POOL_ID'] ?? 'NO_COGNITO_USER_POOL_ID';
  static String cognitoClientId = dotenv.env['COGNITO_CLIENT_ID'] ?? 'NO_COGNITO_CLIENT_ID';

  static String apiBaseUrl = dotenv.env['API_BASE_URL'] ?? 'NO_API_BASE_URL';
}

class ClientConfig {
  static ClientConfigData? _clientConfigData;

  static ClientConfigData getClientConfig() {
    if (_clientConfigData == null) {
      String client = const String.fromEnvironment('CLIENT');
      switch (client) {
        case 'porsche':
          _clientConfigData = ClientConfigData(uiSettings: PorscheTheme.clientUiSettings);
        default:
          _clientConfigData = ClientConfigData(uiSettings: DefaultTheme.clientUiSettings);
      }
    }

    return _clientConfigData!;
  }

  static CustomClientUiSettings getCustomClientUiSettings() {
    return getClientConfig().uiSettings.customSettings;
  }

  static ColorScheme getColorScheme() {
    return getClientConfig().uiSettings.colorscheme;
  }

  static TextStyleScheme getTextStyleScheme() {
    return getClientConfig().uiSettings.labelTextStyle;
  }

  static String getClientImagePath() {
    String client = const String.fromEnvironment('CLIENT');
    switch (client) {
      case 'porsche':
        return 'assets/images/porsche';
      default:
        return 'assets/images/default';
    }
  }

  static String getClientIconPath() {
    String client = const String.fromEnvironment('CLIENT');
    switch (client) {
      case 'porsche':
        return 'assets/icons/porsche';
      default:
        return 'assets/icons/default';
    }
  }

  static String getAssetImagePath(String filename) {
    return join(getClientImagePath(), filename);
  }

  static String getAssetIconPath(String filename) {
    return join(getClientIconPath(), filename);
  }
}

class ClientConfigData {
  final ClientUiSettings uiSettings;
  //add backend accesss data

  const ClientConfigData({required this.uiSettings});
}
