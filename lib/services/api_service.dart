import 'dart:convert';
import 'dart:developer';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/user.dart';

class ApiService<T> {
  User? user;

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
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw Exception("Could not get data");
    }
  }

  Future<T> post(
    String path, {
    Map<String, String> queryParameters = const {},
    Map<String, dynamic> body = const {},
    bool authNeeded = true,
  }) async {
    try {
      String? accessToken = authNeeded ? await this.getAccessToken() : "";

      final response = await http.post(
        ApiService.url(path, queryParameters: queryParameters),
        headers: authNeeded & accessToken.isNotEmpty
            ? {
                "Authorization": "Bearer $accessToken",
              }
            : {},
        body: jsonEncode(body),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("POST request response code: ${response.statusCode}");
      }

      return jsonDecode(response.body);
    } catch (e) {
      log(e.toString());
      throw Exception("Could not post data");
    }
  }

  Future<T> delete(
    String path, {
    Map<String, String> queryParameters = const {},
    Map<String, dynamic> body = const {},
    bool authNeeded = true,
  }) async {
    try {
      String? accessToken = authNeeded ? await this.getAccessToken() : "";

      final response = await http.delete(
        ApiService.url(path, queryParameters: queryParameters),
        headers: authNeeded & accessToken.isNotEmpty
            ? {
                "Authorization": "Bearer $accessToken",
              }
            : {},
        body: jsonEncode(body),
      );
      if (![200, 204].contains(response.statusCode)) {
        throw Exception("DELETE request response code: ${response.statusCode}");
      }

      return response.body.isNotEmpty ? jsonDecode(response.body) : {};
    } catch (e) {
      log(e.toString());
      throw Exception("DELETE request failed");
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
    if (!user!.session.isValid()) {
      CognitoUserSession? session = await user!.cognitoUser.getSession();
      user!.session = session!;
    }

    return user!.session.getAccessToken().jwtToken!;
  }
}
