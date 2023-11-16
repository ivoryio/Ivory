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
    bool authNeeded = true,
  }) async {
    try {
      String? accessToken;

      if (authNeeded) {
        accessToken = await this.getAccessToken();
      }

      final response = await http.get(
        ApiService.url(path, queryParameters: queryParameters),
        headers: authNeeded && accessToken != null ? {"Authorization": "Bearer $accessToken"} : {},
      );

      log(response.body, name: "GET $path $queryParameters RESPONSE");
      if (response.statusCode != 200) {
        throw Exception("GET request response code: ${response.statusCode}");
      }
      final decodedData = utf8.decode(response.bodyBytes);
      return jsonDecode(decodedData);
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  Future<T> post(
    String path, {
    Map<String, String> queryParameters = const {},
    Map<String, dynamic> body = const {},
    bool authNeeded = true,
  }) async {
    try {
      final requestBody = jsonEncode(body);
      String? accessToken;

      if (authNeeded) {
        accessToken = await this.getAccessToken();
      }

      log(requestBody, name: "POST $path $queryParameters REQUEST");
      final response = await http.post(
        ApiService.url(path, queryParameters: queryParameters),
        headers: authNeeded && accessToken != null ? {"Authorization": "Bearer $accessToken"} : {},
        body: requestBody,
      );

      log(response.body, name: "POST $path $queryParameters RESPONSE");
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw HttpException(method: "POST", statusCode: response.statusCode);
      }

      return jsonDecode(response.body);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<T> patch(
    String path, {
    Map<String, String> queryParameters = const {},
    Map<String, dynamic> body = const {},
    bool authNeeded = true,
  }) async {
    try {
      final requestBody = jsonEncode(body);
      String? accessToken;

      if (authNeeded) {
        accessToken = await this.getAccessToken();
      }

      log(requestBody, name: "PATCH $path $queryParameters REQUEST");
      final response = await http.patch(
        ApiService.url(path, queryParameters: queryParameters),
        headers: authNeeded && accessToken != null ? {"Authorization": "Bearer $accessToken"} : {},
        body: requestBody,
      );

      log(response.body, name: "PATCH $path $queryParameters RESPONSE");
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw HttpException(method: "PATCH", statusCode: response.statusCode);
      }

      return jsonDecode(response.body);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<T> delete(
    String path, {
    Map<String, String> queryParameters = const {},
    Map<String, dynamic> body = const {},
    bool authNeeded = true,
  }) async {
    try {
      final requestBody = jsonEncode(body);
      String? accessToken;

      if (authNeeded) {
        accessToken = await this.getAccessToken();
      }

      log(requestBody, name: "DELETE $path $queryParameters REQUEST");
      final response = await http.delete(
        ApiService.url(path, queryParameters: queryParameters),
        headers: authNeeded && accessToken != null ? {"Authorization": "Bearer $accessToken"} : {},
        body: requestBody,
      );

      log(response.body, name: "DELETE $path $queryParameters RESPONSE");
      if (response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 204) {
        throw HttpException(method: "DELETE", statusCode: response.statusCode);
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

class HttpException implements Exception {
  final String method;
  final String message;
  final int statusCode;

  HttpException({
    required this.method,
    this.message = "HTTP request failed",
    this.statusCode = 500,
    StackTrace? stackTrace,
  }) {
    // log("$method request failed with statusCode: $statusCode");
  }

  @override
  String toString() {
    return "$method request failed with statusCode: $statusCode";
  }
}
