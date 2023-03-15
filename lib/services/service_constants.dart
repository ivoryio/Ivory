import 'package:flutter/foundation.dart';

const String androidBaseUrl = 'http://10.0.2.2:8080';

String apiBaseUrl = defaultTargetPlatform == TargetPlatform.android
    ? androidBaseUrl
    : 'http://localhost:8080';

String oauthEndpointUrl = '$apiBaseUrl/oauth/token';
