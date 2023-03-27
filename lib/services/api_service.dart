import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/user.dart';

class ApiService<T> {
  User user;

  ApiService({required this.user});

  Future<T> get(String path) async {
    try {
      String url = '${Config.apiBaseUrl}/$path';
      String? accessToken = user.session.getAccessToken().getJwtToken();

      final response = await http.get(
        Uri.parse(url),
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
}
