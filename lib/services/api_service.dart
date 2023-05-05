import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:amazon_cognito_identity_dart_2/cognito.dart';

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
      if (response.statusCode != 200) {
        throw Exception("GET request response code: ${response.statusCode}");
      }

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception("Could not get data");
    }
  }

  Future<T> post(
    String path, {
    Map<String, String> queryParameters = const {},
    Map<String, dynamic> body = const {},
  }) async {
    try {
      String? accessToken = await this.getAccessToken();

      final response = await http.post(
        ApiService.url(path, queryParameters: queryParameters),
        headers: {
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode(body),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("POST request response code: ${response.statusCode}");
      }

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception("Could not post data");
    }
  }

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
