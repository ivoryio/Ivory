import 'dart:convert';

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
      String? accessToken = user.session.getAccessToken().getJwtToken();

      final response = await http.get(
        ApiService.url(path, queryParameters: queryParameters),
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      }
      throw Exception('Could not get data');
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
}
