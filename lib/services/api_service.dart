import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/user.dart';

class ApiService<T> {
  User user;

  ApiService({required this.user});

  Future<T> get(
    String path, {
    Map<String, String> queryParameters = const {},
  }) async {
    try {
      String? accessToken = await this.getAccessToken();

      final response = await http.get(
        ApiService.url(path, queryParameters: queryParameters),
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      );

      var data = jsonDecode(response.body);
      return data;
    } catch (e) {
      throw Exception("Could not get data");
    }
  }

  post() {}

  static url(String path, {Map<String, String> queryParameters = const {}}) {
    return Uri.https(
      Config.apiBaseUrl,
      path,
      queryParameters,
    );
  }

  Future<String> getAccessToken() async {
    if (!user.session.isValid()) {
      CognitoUserSession? session = await user.cognitoUser.getSession();
      user.session = session!;
    }

    return user.session.getAccessToken().jwtToken!;
  }
}
